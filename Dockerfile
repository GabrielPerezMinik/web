# Usa la imagen de .NET Core en Alpine como base
FROM mcr.microsoft.com/dotnet/core/sdk:latest-alpine3.14 AS build
WORKDIR /app

# Copia el archivo csproj y restaura las dependencias
COPY *.csproj ./
RUN dotnet restore

# Copia todo el contenido y compila la aplicaci�n
COPY . ./
RUN dotnet publish -c Release -o out

# Crea la imagen de producci�n m�s liviana
FROM mcr.microsoft.com/dotnet/core/aspnet:latest-alpine3.14 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Expone el puerto en el que la aplicaci�n est� escuchando
EXPOSE 80

# Define el comando de inicio para correr la aplicaci�n
ENTRYPOINT ["dotnet", "Mi primer Proyecto Web.dll"]
