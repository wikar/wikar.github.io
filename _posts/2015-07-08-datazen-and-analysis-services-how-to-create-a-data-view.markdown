---
published: false
title: Datazen and Analysis Services - How to create a Data View
layout: post
tags: [datazen, ssas, analysis-services, multidimensional, olap]
categories: [Datazen]
---
```
SELECT { [Measures].[Reseller Sales Amount] } ON COLUMNS
,  NON EMPTY { [Date].[Fiscal].[Month] } ON ROWS
FROM [Adventure Works]
```

```
WITH MEMBER [Measures].[Month] AS [Date].[Fiscal].CurrentMember.NAME
SELECT { [Measures].[Month], [Measures].[Reseller Sales Amount] } ON COLUMNS
,  NON EMPTY { [Date].[Fiscal].[Month] } ON ROWS
FROM [Adventure Works]
```