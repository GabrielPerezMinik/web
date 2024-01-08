# Usa la imagen de .NET Core en Alpine como base
FROM nginx:1.25-alpine3.18
COPY . /usr/share/nginx/html
WORKDIR /app

# Copia el archivo csproj y restaura las dependencias
COPY *.csproj ./
RUN dotnet restore

# Copia todo el contenido y compila la aplicación
COPY . ./
RUN dotnet publish -c Release -o out

# Crea la imagen de producción más liviana
FROM mcr.microsoft.com/dotnet/core/aspnet:latest-alpine3.14 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Expone el puerto en el que la aplicación está escuchando
EXPOSE 80

# Define el comando de inicio para correr la aplicación
ENTRYPOINT ["dotnet", "Mi primer Proyecto Web.dll"]
