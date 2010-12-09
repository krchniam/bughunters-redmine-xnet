Redmine Charts
==============

Plugin which integrates with Redmine following charts: burndown, timeline, ratios of logged hours and issues, deviations of logged hours. 

## Instalation

Download the sources and put them to your vendor/plugins folder.

    $ cd {REDMINE_ROOT}
    $ git clone git://github.com/mszczytowski/redmine_charts.git vendor/plugins/redmine_charts

Install OpenFlashChart plugin. 

    $ ./script/plugin install git://github.com/pullmonkey/open_flash_chart.git

Migrate database.

    $ rake db:migrate:plugins

Populate tables with old data.

    $ rake charts:migrate

Run Redmine and have a fun!

## Troubleshouting

### I don't see any data in charts / I don't see my old data in charts

Run migration task "charts:migrate" to populate tables used by plugin with Your old data.

### I don't see charts tab / I don't see link to add new saved condition

Add permission to Your user.

## Translations

- ja by In Dow
- pt-br by Enderson Maia
- nl by onno-schuit
- en by Maciej Szczytowski and Rocco Stanzione
- ru by Vadim Kruchkov
- es by Rafael Lorenzo, José Javier Sianes Ruiz 
- pl by Maciej Szczytowski
- fr by Yannick Quenec'hdu
- ko by Ki Won Kim
- da by Jakob Skjerning
- de by Bernd Engelsing

Thanks for the contribution. 

## Changelog

### 0.1.0

- migration to Redmine 0.9.x
- new conditions (owners, authors, statuses and projects)
- conditions in burndown chart
- multiselection in conditions (#3)
- new issue chart (#2)
- issues with closed status are considered as 100% complete (#1)
- new translations (ko, da, de)
- new chart - burndown with velocity (#12)
- support for subissues (#36)
- saved condition (#24)

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

## Screenshots

![](http://farm4.static.flickr.com/3568/4599631980_fe37fc3fd7_o.jpg)

![](http://farm5.static.flickr.com/4035/4599631940_3b4d1a2642_o.jpg)

![](http://farm2.static.flickr.com/1298/4599014565_1d9be4c04d_o.jpg)

![](http://farm2.static.flickr.com/1159/4599014491_c22cba7925_o.jpg)

![](http://farm2.static.flickr.com/1056/4599014527_d8b7b6457f_o.jpg)

![](http://farm2.static.flickr.com/1401/4599631776_65e0d0bfa2_o.jpg)