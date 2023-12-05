//******************************************************************************
//
// Copyright (c) 2022 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
//******************************************************************************

using Flee.PublicTypes;

if (args.Length == 1)
{
	string commandStr = args[0];
	ExpressionContext context = new ExpressionContext();
	context.Imports.AddType(typeof(Math));
	IDynamicExpression eDynamic = context.CompileDynamic(commandStr);
	var result = eDynamic.Evaluate();
	Console.Write(result);
}
else
{
	Console.WriteLine("Invalid argument");
}