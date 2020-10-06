rm(list = ls(all.names = TRUE))
gc()
library(raster)
XaRaster=raster('NDVI_1.tif')
XbRaster=raster('NDVI_2.tif')
YaRaster=raster('NDMI_1.tif')
YbRaster=raster('NDMI_2.tif')

#DELTA
Xdelta=(XbRaster-XaRaster)
Ydelta=(YbRaster-YaRaster)
Xdelta2=((Xdelta)^2)
Ydelta2=((Ydelta)^2)

#MAPA ZMIAN WIELKOSCI WEKTORA
##Magnitude Map
MG=sqrt(Xdelta2+Ydelta2)
plot(MG,col=grey.colors(255),main='Magnitude Map',xlab=4968, ylab=2895)
writeRaster(MG, "MagnitudeMap.tiff",format="GTiff", overwrite=TRUE, NAflag=-9999)
hist(MG,main='Histogram of Magnitude Map',ylab='Number of Pixels',xlab='Magnitude')

#PROG ZMIAN
##Treshold
library(data.table)
MGMatrix<-matrix(MG)
MGMatrix<-as.data.table(MG)
MGMatrix[is.na(MGMatrix)]<-0
StandDevMG=sd(as.integer(MGMatrix))
StandDevMG
MeanMG=mean(MGMatrix)
MeanMG
Treshold=StandDevMG+MeanMG
Treshold

#Change Map
ChangeMap=(MG>Treshold)
plot(ChangeMap)


#Mapa zmian katow wektora
##Angle Map
Delta=(Ydelta2/Xdelta2)
AngleMap=atan(Delta)
MaxAngle=max(AngleMap)
MinAngle=min(AngleMap)
plot(AngleMap)
writeRaster(AngleMap, "AngleMap.tiff",format="GTiff", overwrite=TRUE, NAflag=-9999)

#Ostateczna mapa zmiany
##Change Map
ChangeMap2=AngleMap/360
ChangeMap3=ChangeMap2*ChangeMap
ChangeMap4=ChangeMap3*360
myCol<-colormap(colormap=c())
plot(ChangeMap4,breaks=c(0,90,180,270),col=myCol)
writeRaster(ChangeMap4, "ChangeMap.tiff",format="GTiff",breaks=c(0,90,180,270),col=myCol, overwrite=TRUE, NAflag=-9999)

