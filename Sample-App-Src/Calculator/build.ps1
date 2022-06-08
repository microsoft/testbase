dotnet publish "./CalculatorCLI" -r win-x64 -c Release -o "./CalculatorCLI/drop"
& npm install
& npm run pack
Pop-Location