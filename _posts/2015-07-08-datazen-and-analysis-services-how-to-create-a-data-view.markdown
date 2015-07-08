---
published: true
title: Datazen and Analysis Services - How to create a Data View
layout: post
tags: [datazen, ssas, analysis-services, multidimensional, olap, mdx]
categories: [Datazen]
---
#Background

Datazen supports Analysis Services as a data source but creating the data views isn't as straight forward as one could expect. In the documentation details on how to write queries against Analysis Services are pretty scarce. The following is written in the section about [Data Providers](http://www.datazen.com/docs/?article=server/data_source_types). 

>Data View Query -The MDX query to perform. Must return a single table of data. Any Dimension hierarchy which needs to be returned as part of the view must be expressed as a defined Member in the MDX Query.

This was still not crystal clear to me and it took a couple of tries to achieve the expected result set. Based on my experiences I have written a brief tutorial of a working query below using Adventure Works.

#Regular query

Using a regular query showing the sales by month with the measure on the column axis and the dimension on the rows.

```
SELECT { [Measures].[Reseller Sales Amount] } ON COLUMNS
,  NON EMPTY { [Date].[Fiscal].[Month] } ON ROWS
FROM [Adventure Works]
```

![create-new-mdx-query-without-measure-member-expression](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-07-08-datazen-and-analysis-services-how-to-create-a-data-view/2-create-new-mdx-query-without-measure-member-expression.png)

The resulting result set only contains the measures and hides away the dimension members.

![data-view-resultset-without-measure-member-expression](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-07-08-datazen-and-analysis-services-how-to-create-a-data-view/3-data-view-resultset-without-measure-member-expression.png)

And as a result the dimension members isn't accessible as a column in Datazen Designer either.

![datazen-publisher-without-measure-member-expression](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-07-08-datazen-and-analysis-services-how-to-create-a-data-view/4-datazen-publisher-without-measure-member-expression.png)

#Query with dimension defined as a member

As stated in the documentation Datazen expects to receive everything as members, even the dimensions. In order to include also the dimension members in the result set we'll have to rewrite the query as below.

```
WITH MEMBER [Measures].[Month] AS [Date].[Fiscal].CurrentMember.NAME
SELECT { [Measures].[Month], [Measures].[Reseller Sales Amount] } ON COLUMNS
,  NON EMPTY { [Date].[Fiscal].[Month] } ON ROWS
FROM [Adventure Works]
```

![create-new-mdx-query-with-measure-member-expression](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-07-08-datazen-and-analysis-services-how-to-create-a-data-view/5-create-new-mdx-query-with-measure-member-expression.png)

And voilà!

![data-view-resultset-with-measure-member-expression](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-07-08-datazen-and-analysis-services-how-to-create-a-data-view/6-data-view-resultset-with-measure-member-expression.png)

Now we also have the months in Datazen Designer ready to be used in the dashboard element data properties.

![datazen-publisher-with-measure-member-expression](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-07-08-datazen-and-analysis-services-how-to-create-a-data-view/7-datazen-publisher-with-measure-member-expression.png)

Hope this will help someone get started using Datazen with Analysis Services!

For more information on defining query-scoped members see this article on MSDN: [Creating Query-Scoped Calculated Members (MDX)](https://msdn.microsoft.com/en-us/library/ms146017.aspx)