# ---- Stage 1: Build the application ----
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
COPY ["FreelanceExchange", "."]
RUN dotnet restore "FreelanceExchange.csproj"

# Copy the remaining source code and publish the app
COPY . .
RUN dotnet publish "FreelanceExchange.csproj" -c Release -o /app/publish

# ---- Stage 2: Run the application ----
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
EXPOSE 8080

# Copy the published app from the build stage
COPY --from=build /app/publish .

# Tell the app which port to listen on (Render requires port 8080)[reference:1][reference:2]
ENV ASPNETCORE_URLS=http://+:8080

# Run the application
ENTRYPOINT ["dotnet", "FreelanceExchange.dll"]