---
title: Exploring Kiva loans
author: Ángela Castillo-Gill
profile: TRUE
date: '2018-07-07'
slug: exploring-kiva-loans
categories:
  - R
  - End-to-end
  - Exploratory data analysis
tags: 
  - Kaggle
  - Kiva
draft: FALSE
summary: What do Kiva loans around the world look like?
image:
  preview_only: FALSE
header: 
  image: "headers/lenders-per-country-1.png"
  caption: "Lender counts per country for top borrowing countries."
output:
  blogdown::html_page:
    toc: true
    number_sections: true
    toc_depth: 2
  fig_caption: true
editor_options: 
  chunk_output_type: console
---


# Summary

*To see the code used in this post, visit my [kernel on kaggle in R Markdown format](https://www.kaggle.com/adcastillogill/exploring-kiva-loans).* 

In this post, I analyse 671,205 observations. Each represents a [Kiva](www.kiva.org) loan. I find that the gender that requests the most loans is female with single females being the most frequent borrowers. The main uses for these loans are agriculture, retail, and food with some variations amongst continents. Half of the loans are 4.22 USD or less and are funded by 12 or less contributers. The median time between posting a loan online and disbursing it to the borrower is 16.89 days. I mainly use the `tidyverse`, `stringr`, and `quantmode` packages. 

# Purpose of this post

Muhammad Yunus and the Grameen Bank won the [Nobel Peace Prize](https://www.nobelpeaceprize.org/Prize-winners/Winners/2006) in 2006 for "their efforts through microcredit to create economic and social development from below."

Back in 1976, Yunus, at the time a professor at the University of Chittagong (Bangladesh), [noticed that small amounts of money could make a substantial difference to people living in poverty](https://www.bbc.co.uk/news/world-south-asia-11901625). He started to loan money to people that didn't meet the requirements listed by the mainstream banking system. It was reported that these type of loans were effective to ["emerge" from poverty](https://www.nobelpeaceprize.org/Prize-winners/Prizewinner-documentation/Muhammad-Yunus-Grameen-Bank) using default rates lower than those of commercial banks, [reported at 2%](https://www.gdrc.org/icm/grameen-article4.html). Eventually, in October 1983, Muhammad Yunus founded [Grameen Bank](https://grameenfoundation.org/about/history), considered to be the first microfinance institution. 

Founded in 2005, [Kiva](www.kiva.org), has the same mission as Grameen Bank except that anyone can become a Kiva banker. This online platform enables microcredit lending to help low-income entrepreneurs around the world with a couple of clicks. Pretty neat, huh? In this post, I unpack a large dataset published by [Kiva on the Kaggle platform](https://www.kaggle.com/kiva/data-science-for-good-kiva-crowdfunding) and explore these microloans. 

# The data

The dataset was published during the first months of 2018 on the [Kaggle platform](https://www.kaggle.com/kiva/data-science-for-good-kiva-crowdfunding). 

The complete dataset was a zip file with size 232.7 MB containing four files: `kiva_loans.csv`, `kiva_mpi_region_locations.csv`,`loan_theme_ids.csv`, and `loan_themes_by_region.csv`. After I looked at the contents, I chose to work with the first one `kiva_loans.csv`.



The dataset had 671,205 observations and 20 variables.



Some of the codebook came with the dataset and some I researched to make assumptions:

- `funded_amount`: "The amount disbursed by Kiva to the field agent(USD)"
- `loan_amount`: "The amount disbursed by the field agent to the borrower(USD)"
- `activity`: "More granular category"
- `sector`: "High level category"
- `use`: "Exact usage of loan amount"
- `country_code`: "ISO country code of country in which loan was disbursed"
- `country`: "Full country name of country in which loan was disbursed"
- `region`: "Full region name within the country"
- `currency`: "The currency in which the loan was disbursed"
- `partner_id`: "ID of partner organization"

This variable has a lot of missing values and the Kiva explanation on Kaggle doesn't go much further. For now, I will exclude `partner_id`. 

- `posted_time`: "The time at which the loan is posted on Kiva by the field agent"
- `disbursed_time`: "The time at which the loan is disbursed by the field agent to the borrower"
- `funded_time`: "The time at which the loan posted to Kiva gets funded by lenders completely"
- `term_in_months`: "The duration for which the loan was disbursed in months"
- `lender_count`: "The total number of lenders that contributed to this loan"
- `borrower_genders`: "Comma separated M,F letters, where each instance represents a single male/female in the group"
- `repayment_interval`: Not specified so we'll assume that it means the standard definition of when the loan is repaid back to the lender.

# Data cleaning 


From  at the structure of our data, we can soon see there are a few bits that don't make sense and need to be fixed. 

**a. Missing values**

We will leave missing values in for now. 

**b. `borrower_genders`**

From the variable descriptions, we expected `borrower_genders`to have only two levels, `male`or `female`. Here we see many more levels, 11,298 to be precise. This isn't very clear so we'll fix that first by creating five levels:




```
[1] "mixed_genders" "mult_females"  "mult_males"    "single_female"
[5] "single_male"  
```

**c. `loan_amounts`**

Now, since we're trying to make sense of all loans, it's better if `loan_amounts` is in the same currency. Let's translate it to USD.








**d. `country_codes`**

Finally, with 86 countries, we have 86 levels. Perhaps it would be interesting to create another category called continent to produce less levels and have a better understanding of the overall function of regional distributions.

Our country codes are in the ISO3166 format, so we will use the associated continent code found [here](https://dev.maxmind.com/geoip/legacy/codes/country_continent/). And make five continents. Africa, Asia, Europe, Oceania, and South America.






```
[1] "AF" "AS" "EU" "OC" "SA"
```


**e. Dates**

Let's calculate two lengths of time that I think are interesting. First, how much time passes from the moment the loan is posted to the moment it's disbursed (`total_time`). Second, how long does a loan take to get funded (`giving_time`)? 





# Exploratory data analysis

Now, let's describe the data starting with some plots and tables to understand it.



<div class="figure">
<img src="/post/2018-07-09-exploring-kiva-loans/2018-07-09-exploring-kiva-loans_files/figure-html/continent-and-borrower-genders-plots-1.png" alt="Four continents in descending order from the continent that requests the most loans (Asia). Notice Europe and North America do not appear. `mult_females` or `mult_males` means more than one female or male." width="960" />
<p class="caption">Figure 1 Four continents in descending order from the continent that requests the most loans (Asia). Notice Europe and North America do not appear. `mult_females` or `mult_males` means more than one female or male.</p>
</div>

<table class="table table-striped table-hover table-condensed" style="margin-left: auto; margin-right: auto;">
<caption>Table 1 A single female is the most common type of borrower gender with over half of all Kiva loans requested.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Gender </th>
   <th style="text-align:right;"> Percentage </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> single_female </td>
   <td style="text-align:right;"> 65.82 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> single_male </td>
   <td style="text-align:right;"> 17.43 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> mult_females </td>
   <td style="text-align:right;"> 9.58 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> mixed_genders </td>
   <td style="text-align:right;"> 6.58 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> mult_males </td>
   <td style="text-align:right;"> 0.59 </td>
  </tr>
</tbody>
</table>

In all continents, single females request the most loans followed by single males. In Asia and South America, the third category is multiple females while in Africa it's mixed genders. 

<div class="figure">
<img src="/post/2018-07-09-exploring-kiva-loans/2018-07-09-exploring-kiva-loans_files/figure-html/repayment-interval-and-continent-1.png" alt="In Asia and Oceania, the most popular repayment interval is irregular while in Africa and South America it's monthly." width="960" />
<p class="caption">Figure 2 In Asia and Oceania, the most popular repayment interval is irregular while in Africa and South America it's monthly.</p>
</div>

<table class="table table-striped table-hover table-condensed" style="margin-left: auto; margin-right: auto;">
<caption>Table 2 The most popular type of repayment interval is monthly.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Repayment interval </th>
   <th style="text-align:right;"> Percentage </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> monthly </td>
   <td style="text-align:right;"> 47 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> irregular </td>
   <td style="text-align:right;"> 43 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> bullet </td>
   <td style="text-align:right;"> 10 </td>
  </tr>
</tbody>
</table>

<div class="figure">
<img src="/post/2018-07-09-exploring-kiva-loans/2018-07-09-exploring-kiva-loans_files/figure-html/sectors-and-continents-1.png" alt="In every continent, the three most popular sectors are agriculture, retail, and food." width="960" />
<p class="caption">Figure 3 In every continent, the three most popular sectors are agriculture, retail, and food.</p>
</div>

<table class="table table-striped table-hover table-condensed" style="margin-left: auto; margin-right: auto;">
<caption>Table 3 Generally, the most frequent use of loans is agriculture, followed by food and retail.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Sector </th>
   <th style="text-align:right;"> Percentage </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Agriculture </td>
   <td style="text-align:right;"> 27.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Food </td>
   <td style="text-align:right;"> 20.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Retail </td>
   <td style="text-align:right;"> 19.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Services </td>
   <td style="text-align:right;"> 6.9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Personal Use </td>
   <td style="text-align:right;"> 5.9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Education </td>
   <td style="text-align:right;"> 5.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Clothing </td>
   <td style="text-align:right;"> 4.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Housing </td>
   <td style="text-align:right;"> 4.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Transportation </td>
   <td style="text-align:right;"> 2.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Arts </td>
   <td style="text-align:right;"> 1.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Health </td>
   <td style="text-align:right;"> 1.2 </td>
  </tr>
</tbody>
</table>

<table class="table table-striped table-hover table-condensed" style="margin-left: auto; margin-right: auto;">
<caption>Table 4 Half of all Kiva loans are requested in Asia followed by Africa, South America, Oceania and finally the European Union.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Continents </th>
   <th style="text-align:right;"> Percentage </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> AS </td>
   <td style="text-align:right;"> 55.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AF </td>
   <td style="text-align:right;"> 29.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SA </td>
   <td style="text-align:right;"> 13.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> OC </td>
   <td style="text-align:right;"> 1.4 </td>
  </tr>
</tbody>
</table>

Notice most loans are requested by single females, the least amount of loans are given in the EU, weekly repayment is an unpopular form of paying loans back and entertainment, wholesale, manufacturing, and construction amount less than 2.2% of sectors.

<div class="figure">
<img src="/post/2018-07-09-exploring-kiva-loans/2018-07-09-exploring-kiva-loans_files/figure-html/countries-plot-1.png" alt="Philippines requests the mosts loans with over double as the second country, Kenya `KE`. Other top countries in this ranking are Cambodia `KH`, Pakistan `PK`, Peru `PE`, Colombia `CO`, Uganda `UG`, Tajikistan `TJ`, Ecuador `EC`, and Paraguay `PY`." width="768" />
<p class="caption">Figure 4 Philippines requests the mosts loans with over double as the second country, Kenya `KE`. Other top countries in this ranking are Cambodia `KH`, Pakistan `PK`, Peru `PE`, Colombia `CO`, Uganda `UG`, Tajikistan `TJ`, Ecuador `EC`, and Paraguay `PY`.</p>
</div>

Now I'm curious to look at the top 10 countries requesting Kiva loans but per capita and per number of internet users.







<div class="figure">
<img src="/post/2018-07-09-exploring-kiva-loans/2018-07-09-exploring-kiva-loans_files/figure-html/countries-plot-capita-1.png" alt="Interesting to see how the ranking changed! The island of Samoa `WS` is leading, followed by Armenia `AM`. Countries that remain in the top 10 are Cambodia `KH`, Philippines `PH`, Kenya `KE`, and Tajikstan `TJ`. Other new countries are Timor-Leste `TL`, Paraguay `PY`, Palestine `PS`, and Lebanon `LB`." width="672" />
<p class="caption">Figure 5 Interesting to see how the ranking changed! The island of Samoa `WS` is leading, followed by Armenia `AM`. Countries that remain in the top 10 are Cambodia `KH`, Philippines `PH`, Kenya `KE`, and Tajikstan `TJ`. Other new countries are Timor-Leste `TL`, Paraguay `PY`, Palestine `PS`, and Lebanon `LB`.</p>
</div>

Let's see how the top 10 changes when it comes to internet users. I used [this ranking](https://en.wikipedia.org/wiki/List_of_countries_by_number_of_Internet_users), which is based on numbers published by the [International Telecommunications Union](https://www.itu.int/en/Pages/default.aspx).



<div class="figure">
<img src="/post/2018-07-09-exploring-kiva-loans/2018-07-09-exploring-kiva-loans_files/figure-html/countries-plot-users-1.png" alt="Interesting to see how the ranking changed! Leading the charts is the island of Samoa, followed by Armenia. Countries that remain in the top 10 are Cambodia `KH`, Philippines `PH`, Kenya `KE`, and Tajikstan `TJ`. Other new countries are Timor-Leste `TL`, Paraguay `PY`, Palestine `PS`, and Lebanon `LB`." width="672" />
<p class="caption">Figure 6 Interesting to see how the ranking changed! Leading the charts is the island of Samoa, followed by Armenia. Countries that remain in the top 10 are Cambodia `KH`, Philippines `PH`, Kenya `KE`, and Tajikstan `TJ`. Other new countries are Timor-Leste `TL`, Paraguay `PY`, Palestine `PS`, and Lebanon `LB`.</p>
</div>

Now let's look at the distributions of our numeric variables.

<div class="figure">
<img src="/post/2018-07-09-exploring-kiva-loans/2018-07-09-exploring-kiva-loans_files/figure-html/loan-usd-distribution-1.png" alt="Half of Kiva loans are 4.22 USD or less. Although the maximum loan is 100,000 USD, 75% of loans are equal to or less than 89.79 USD." width="672" />
<p class="caption">Figure 7 Half of Kiva loans are 4.22 USD or less. Although the maximum loan is 100,000 USD, 75% of loans are equal to or less than 89.79 USD.</p>
</div>


<div class="figure">
<img src="/post/2018-07-09-exploring-kiva-loans/2018-07-09-exploring-kiva-loans_files/figure-html/term-in-months-distribution-1.png" alt="The loan term in months is a bimodal distribution with its first peak around 8 months and its second around 12, the median." width="672" />
<p class="caption">Figure 8 The loan term in months is a bimodal distribution with its first peak around 8 months and its second around 12, the median.</p>
</div>

<div class="figure">
<img src="/post/2018-07-09-exploring-kiva-loans/2018-07-09-exploring-kiva-loans_files/figure-html/lender-count-1.png" alt="The lender count has a text book right-skewed distribution with a median of 12 lenders." width="672" />
<p class="caption">Figure 9 The lender count has a text book right-skewed distribution with a median of 12 lenders.</p>
</div>
 




<div class="figure">
<img src="/post/2018-07-09-exploring-kiva-loans/2018-07-09-exploring-kiva-loans_files/figure-html/lenders-per-country-1.png" alt="Lender count ranges between 5 and 40 for the top 16 countries that request the most Kiva loans." width="672" />
<p class="caption">Figure 10 Lender count ranges between 5 and 40 for the top 16 countries that request the most Kiva loans.</p>
</div>


 
<div class="figure">
<img src="/post/2018-07-09-exploring-kiva-loans/2018-07-09-exploring-kiva-loans_files/figure-html/giving-time-1.png" alt="The median time between posting the loan and the loan being fully funded is about 9.2 days. It is a bimodal distribution with its first peak around 6 days and its second peak around 30 days." width="672" />
<p class="caption">Figure 11 The median time between posting the loan and the loan being fully funded is about 9.2 days. It is a bimodal distribution with its first peak around 6 days and its second peak around 30 days.</p>
</div>

<div class="figure">
<img src="/post/2018-07-09-exploring-kiva-loans/2018-07-09-exploring-kiva-loans_files/figure-html/total-time-1.png" alt="The total time between posting the loan and it being disbursed has a funky looking multimodal distribution. It seems to be cut off at 30 days with peaks at 7, 14, 21 and 30 days. Median time is 17.2 days." width="672" />
<p class="caption">Figure 12 The total time between posting the loan and it being disbursed has a funky looking multimodal distribution. It seems to be cut off at 30 days with peaks at 7, 14, 21 and 30 days. Median time is 17.2 days.</p>
</div>

# Techniques used

- I used the `quantmode` package to convert all loans into a unique currency (US dollars) for comparison. There were two currencies that were unavailable.

- Taking all the different levels that came in the `borrower_genders` variable and creating five neat categories to better understand who are the borrowers was good practice with lists and the `stringr` package. 

# Questions from this analysis

- Why is `Retail` and not `Food` (as in other regions) the second most common use for loans in Asia. 

- Who are the givers? Where are they? Does proximity of the lender to the borrower have anything to do with funding times?

- Does the Kiva website have anything to do with funding times? For example, `giving_time`, the time between posting the loan and the loan being fully funded, has two peaks, at around one week and one month. Is this due to the platform and the promotion of loans that have been posted for a certain amount of time?



