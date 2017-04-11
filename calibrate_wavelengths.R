# install ultrafast monkey with devtools::install_github('tjconstant/ultrafastMonkey')
library(ultrafastMonkey)

wavelengths <- seq(540, 605, 5)

actual_wavelengths <- c()

for (i in 1:length(wavelengths)) {
  result <- read.asc(paste("TOPAS1/", wavelengths[i], ".asc", sep = ""))
  actual_wavelengths <- c(actual_wavelengths, result$lambda_0)
}

print(actual_wavelengths)

a <- data.frame(wavelengths, actual_wavelengths)
names(a) <- c("TOPAS_wavelength", "Actual_wavelength")

write.csv(a, file = "TOPAS1/topas1_calibration.csv", row.names = F)

plot(a$Actual_wavelength, a$TOPAS_wavelength)

fit <- lm(a$TOPAS_wavelength ~ poly(a$Actual_wavelength, 1, raw = T))

lines(a$Actual_wavelength, predict(fit))

x <- seq(550, 615, , 100)
lines(x,
      fit$coefficients[1] + fit$coefficients[2] * x + fit$coefficients[3] * x ^
        2,
      col = 2)

write.csv(fit$coefficients, file = "TOPAS1/topas1_coeffs.csv", row.names = F)