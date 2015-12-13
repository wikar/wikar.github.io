---
published: true
title: Dynamics AX7 (Rainier) - BI/Analytics Preview
layout: post
tags: [dynamics ax, ax, ax7, rainier, bi, analytics]
categories: [DynamicsAX]
---

It has been known for a while that Dynamics AX7 (Codename Rainier) would come with significant changes to the BI & Analytics features. Not much has been known about the details but about a week ago Microsoft released a video revealing some of the upcoming news. Thanks to Nurlin Aberra, [DynaAX](http://www.dynaax.se), for the tip.

You can find the actual video here, [www.youtube.com/watch?v=jepSqjGkuxE](https://www.youtube.com/watch?v=jepSqjGkuxE). I extracted some of the most interesting bits into snippets below together with some personal comments.

### Perspectives

![dax7-bi-preview-02](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-12-12-dynamics-ax-7-bi-preview/dax7-bi-preview-02.png)

Personally I only have experience with BI in AX2012 R3 but have been working with the Microsoft BI stack outside of AX since 2007. The experience of AX BI has been a bit so-so especially since we often want to combine the data from AX with historical data and/or data from other sources. I still see the BI features in AX mainly as operational, analytics closer and more integrated to the business processes.

### Workspaces

![dax7-bi-preview-01](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-12-12-dynamics-ax-7-bi-preview/dax7-bi-preview-01.png)

Moving from the role centers into more personalized and process-centric views - a welcome change.

### Flavors of reporting in Dynamics AX

![dax7-bi-preview-03](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-12-12-dynamics-ax-7-bi-preview/dax7-bi-preview-03.png)

Reporting still feels a bit scattered. Interesting to see whether the new BI features in [SQL Server 2016](http://blogs.technet.com/b/dataplatforminsider/archive/2015/10/29/microsoft-business-intelligence-our-reporting-roadmap.aspx) (such as [Datazen](http://www.datazen.com)) will be leveraged in the on-prem version of AX7.

### How a developer consumes aggregate data in AX7

![dax7-bi-preview-04](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-12-12-dynamics-ax-7-bi-preview/dax7-bi-preview-04.png)

"Aggregate Measurements" becoming an alternative to the SSAS cubes. Initally it was unclear which underlying technology is actually used (In-memory OLTP, Tabular Models, etc) but during the Q&A it was "demystified" by talking about the SQL Server columnstore indexes and read-only secondaries. I have a feel this can't be all to it (same Aggregate Measurments deployed twice to enable Excel self-service analytics?) and it require further detailing ahead.

### In-Memory Real-time vs SSAS Cube

![dax7-bi-preview-05](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-12-12-dynamics-ax-7-bi-preview/dax7-bi-preview-05.png)

Developer view in Visual Studio. Notice the options for both InMemoryRealTime and SSAS Cube.

### AX 2012 BI capabilities are GREAT - but hard to implement

![dax7-bi-preview-06](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-12-12-dynamics-ax-7-bi-preview/dax7-bi-preview-06.png)

Agree to all the boxes in red. Good to see the AX team acknowledging and aiming to fill the gaps.

### Aggregate models - Deployment choices

![dax7-bi-preview-07](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-12-12-dynamics-ax-7-bi-preview/dax7-bi-preview-07.png)

![dax7-bi-preview-08](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-12-12-dynamics-ax-7-bi-preview/dax7-bi-preview-08.png)

Here we can see the difference between the two deployment options. Nonclustered Columnstore Index (NCCI) or SSAS. Multi-dimensional or Tabular not mentioned - referring to MDX a give-away for MOLAP?

### AX7 - Power BI

![dax7-bi-preview-09](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-12-12-dynamics-ax-7-bi-preview/dax7-bi-preview-09.png)

![dax7-bi-preview-10](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-12-12-dynamics-ax-7-bi-preview/dax7-bi-preview-10.png)

![dax7-bi-preview-11](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-12-12-dynamics-ax-7-bi-preview/dax7-bi-preview-11.png)

![dax7-bi-preview-12](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-12-12-dynamics-ax-7-bi-preview/dax7-bi-preview-12.png)

![dax7-bi-preview-13](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2015-12-12-dynamics-ax-7-bi-preview/dax7-bi-preview-13.png)

Not much to mention here apart from it becoming a two-way integration of Power BI. Data out from and reports/dashboards back into AX.

### Data extraction / Data mashup

It was once again expressed that if you want to extract data from AX to integrate into an external data warehouse DIXF is the way to go. If you want to consume data irregularly for data mashups exposing queries through OData will still be available much like [today](https://technet.microsoft.com/en-us/library/dn198214.aspx).