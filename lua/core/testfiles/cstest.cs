// dotnet run — top-level statements (C# 9+)
using System;
using System.Text.Json;

var person = new
{
    Name = "Mava",
    Role = "Polymath",
    Languages = new[] { "C#", "Python", "Lua" },
};
Console.WriteLine("Profile JSON:");
Console.WriteLine(
    JsonSerializer.Serialize(person, new JsonSerializerOptions { WriteIndented = true })
);

// small function
int Square(int x) => x * x;
Console.WriteLine($"Square(7) = {Square(7)}");
