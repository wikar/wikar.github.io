---
published: false
title: Datazen and Analysis Services - How to create a Data View
layout: post
tags: [datazen, ssas, analysis-services, multidimensional, olap]
categories: [Datazen]
---
![1-create-new-data-view-blank](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-07-08-datazen-and-analysis-services-how-to-create-a-data-view/1-create-new-data-view-blank.png

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