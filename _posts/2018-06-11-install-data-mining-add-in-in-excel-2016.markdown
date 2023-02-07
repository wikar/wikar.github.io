---
published: true
title: Install Data Mining Add-in In Excel
layout: post
tags: [excel, data mining, sql server, ssas]
categories: [Excel]
---

**Edit:** This has also been confirmed working in Excel 2019 / 2021 / Office 365.

Ever since the release of Excel 2016 a compatible SQL Server Data Mining Add-in has been missing. There has been numerous requests for Microsoft to release an official update but so far this hasn't happened.

Having Excel 2013 and Excel 2016 installed side-by-side has been used as a workaround to get the Excel 2013 DM Add-In semi-working also for Excel 2016. The following registry hack is allowing the otherwise blocked installation to proceed for Excel 2016 without the need for an actual Excel 2013 installation. 

1. Download [Microsoft® SQL Server® 2012 SP4 Data Mining Add-ins for Microsoft® Office®](https://www.microsoft.com/en-us/download/details.aspx?id=56047) (Latest official version)

1. Insert the following entry in the Windows registry (.reg file [here](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/misc/2018-06-11-install-data-mining-add-in-in-excel-2016/excel-2016-dm-registry-check.reg) but use at your own risk)
![excel2016-hack](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2018-06-11-install-data-mining-add-in-in-excel-2016/regedit_excel_2016_dm_hack.png)

1. Proceed with installation which now shouldn't complain about missing Excel 2010/2013