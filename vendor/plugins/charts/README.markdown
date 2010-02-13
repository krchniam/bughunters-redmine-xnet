Redmine Charts
==============

Plugin for Redmine which integrates some nice project charts.

## Instalation

Download the sources and put them to your vendor/plugins folder.

    $ cd {REDMINE_ROOT}
    $ git clone git://github.com/mszczytowski/redmine_charts.git vendor/plugins/redmine_charts

Install OpenFlashChart plugin. 

    $ ./script/plugin install git://github.com/pullmonkey/open_flash_chart.git

Run Redmine and have a fun!

## Translations

- ja by indication
- pt-br by enderson
- nl by onno-schuit
- en by myself and trappist 
- ru by Vadim Kruchkov
- es by Rafael Lorenzo 
- pl by myself
- fr by Yannick Quenec'hdu

Thanks for contribution. 

## Changelog

### 0.0.14

- new translations (fr)

### 0.0.13

- bug fixes (#13, #15)
- saving charts as images (#14)

### 0.0.12

- many bug fixes (#6, #7, #8, #9, #10)
- new conditions (trackers, priorities, versions)
- pages on deviations chart (#5)
- hours logged for project and not estimated issues on deviations chart

## Charts

### Burndown

Timeline with estimated, logged and remaining hours.

![Screenshot of hours chart](http://farm4.static.flickr.com/3487/3219872709_03a137e740_o.jpg)

### Logged hours ratio

Number of hours were logged proportional to total total, grouped and filtered by users, issues, activities, categories, version, priorities or trackers.

![Screenshot of groups chart](http://farm4.static.flickr.com/3313/3220723922_64540005a0_o.jpg)

### Logged hours timeline

Timeline with logged hours, grouped and filtered by users, issues, activities, categories, version, priorities and trackers.

![Screenshot of hours chart](http://farm4.static.flickr.com/3112/3220723804_2b274e7e2f_o.jpg)

### Logged hours deviations

Ratio of logged and remaining hours to estimated hours for each estimated issue.

![Screenshot of deviations chart](http://farm4.static.flickr.com/3441/3219872389_4f1d105c1d_o.jpg)
