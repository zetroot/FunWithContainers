FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["FunWithContainers/FunWithContainers.csproj", "FunWithContainers/"]
RUN dotnet restore "FunWithContainers/FunWithContainers.csproj"
COPY . .
WORKDIR "/src/FunWithContainers"
RUN dotnet build "FunWithContainers.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "FunWithContainers.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "FunWithContainers.dll"]
