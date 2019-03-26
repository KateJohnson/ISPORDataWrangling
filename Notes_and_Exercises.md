Data Wrangling in R for Health Outcomes Research
================

The objective of this workshop is to provide an introduction to data wrangling in R using the tidyverse. By the end of this workshop, you should be able to:

1.  Use a project oriented workflow and an R markdown document.
2.  Perform simple data manipulations using the 5 dplyr verbs (`select`, `filter`, `arrange`, `mutate`, `summarise`, `group_by`), and chain these operations together using piping (`%>%`).
3.  Join datasets together using the set of `join` functions.

Objective 1: Setting up our workflow
------------------------------------

First, let's load the [tidyverse](https://www.tidyverse.org/), which is an "an opinionated collection of R packages designed for data science. All packages share an underlying design philosophy, grammar, and data structures." The operate in parallel to, and often in place of, the set of packages included in base R.

``` r
#install.packages("tidyverse")
library(tidyverse)
```

    ## -- Attaching packages -------------------------------------------------------------------------------------------------------------------- tidyverse 1.2.1 --

    ## v ggplot2 3.1.0       v purrr   0.3.1  
    ## v tibble  2.0.1       v dplyr   0.8.0.1
    ## v tidyr   0.8.3       v stringr 1.4.0  
    ## v readr   1.3.1       v forcats 0.3.0

    ## -- Conflicts ----------------------------------------------------------------------------------------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
# some other packages that we'll need down the road
#install.packages("here")
library(here)
```

    ## here() starts at C:/Users/katemj91/Google Drive/Workshops/ISPOR/DataWrangling/ISPORDataWrangling

``` r
#install.packages("readr")
library(readr)
```

For this workshop, we're going to work with a dataset from the National Institute of Diabetes and Digestive and Kidney Diseases that I pulled from [kaggle](https://www.kaggle.com). The data was collected for the purpose of developing a model to predict the occurence of diabetes mellitus among a group of Pima Indians. You can find more details on the data [here](https://www.kaggle.com/uciml/pima-indians-diabetes-database).

Let's load the data into R and check it out:

``` r
diabetes <- read_csv(here("Data/diabetes.csv"))
```

    ## Parsed with column specification:
    ## cols(
    ##   ID = col_double(),
    ##   Pregnancies = col_character(),
    ##   Glucose = col_double(),
    ##   BloodPressure = col_double(),
    ##   SkinThickness = col_double(),
    ##   Insulin = col_double(),
    ##   BMI = col_character(),
    ##   DiabetesPedigreeFunction = col_double(),
    ##   Age = col_double(),
    ##   Diabetes = col_double()
    ## )

(Aside: Check out this [this](https://www.tidyverse.org/articles/2017/12/workflow-vs-script/) blogpost by Jenny Bryan about best practices for getting your data into R. *Hint:* if you use code like this: 'rm(list=ls())' she will "set your computer on fire."

Explore the data
----------------

So what do we have here?

``` r
glimpse(diabetes)
```

    ## Observations: 768
    ## Variables: 10
    ## $ ID                       <dbl> 32, 559, 258, 5, 668, 499, 585, 539, ...
    ## $ Pregnancies              <chr> "4-6", "1-3", "7-9", "1-3", "0", "4-6...
    ## $ Glucose                  <dbl> 148, 85, 183, 89, 137, 116, 78, 115, ...
    ## $ BloodPressure            <dbl> 72, 66, 64, 66, 40, 74, 50, 0, 70, 96...
    ## $ SkinThickness            <dbl> 35, 29, 0, 23, 35, 0, 32, 0, 45, 0, 0...
    ## $ Insulin                  <dbl> 0, 0, 0, 94, 168, 0, 88, 0, 543, 0, 0...
    ## $ BMI                      <chr> "Obese", "Overweight", "Normal", "Ove...
    ## $ DiabetesPedigreeFunction <dbl> 0.627, 0.351, 0.672, 0.167, 2.288, 0....
    ## $ Age                      <dbl> 50, 31, 32, 21, 33, 30, 26, 29, 53, 5...
    ## $ Diabetes                 <dbl> 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0...

Let's get some basic summaries of each of the variables so that we have an idea of what's in there:

``` r
summary(diabetes)
```

    ##        ID        Pregnancies           Glucose      BloodPressure   
    ##  Min.   :  1.0   Length:768         Min.   :  0.0   Min.   :  0.00  
    ##  1st Qu.:192.8   Class :character   1st Qu.: 99.0   1st Qu.: 62.00  
    ##  Median :384.5   Mode  :character   Median :117.0   Median : 72.00  
    ##  Mean   :384.5                      Mean   :120.9   Mean   : 69.11  
    ##  3rd Qu.:576.2                      3rd Qu.:140.2   3rd Qu.: 80.00  
    ##  Max.   :768.0                      Max.   :199.0   Max.   :122.00  
    ##  SkinThickness      Insulin          BMI           
    ##  Min.   : 0.00   Min.   :  0.0   Length:768        
    ##  1st Qu.: 0.00   1st Qu.:  0.0   Class :character  
    ##  Median :23.00   Median : 30.5   Mode  :character  
    ##  Mean   :20.54   Mean   : 79.8                     
    ##  3rd Qu.:32.00   3rd Qu.:127.2                     
    ##  Max.   :99.00   Max.   :846.0                     
    ##  DiabetesPedigreeFunction      Age           Diabetes    
    ##  Min.   :0.0780           Min.   :21.00   Min.   :0.000  
    ##  1st Qu.:0.2437           1st Qu.:24.00   1st Qu.:0.000  
    ##  Median :0.3725           Median :29.00   Median :0.000  
    ##  Mean   :0.4719           Mean   :33.24   Mean   :0.349  
    ##  3rd Qu.:0.6262           3rd Qu.:41.00   3rd Qu.:1.000  
    ##  Max.   :2.4200           Max.   :81.00   Max.   :1.000

What are some things we might want to check when we first bring our data into R? Let's list them here:

-   ...

Objective 2: Data manipulations using dplyr
-------------------------------------------

(This summary is taken from the [STAT 545](http://stat545.com/) class notes.)

The six main dplyr functions for data manipulation are:

> -   Pick variables by their names (`select()`).
> -   Pick observations by their values (`filter()`).
> -   Reorder the rows (`arrange()`).
> -   Create new variables with functions of existing variables (`mutate()`).
> -   Collapse many values down to a single summary (`summarise()`).

Then there's `group_by()`, which can be used in conjunction with all of these.

And `%>%` (piping) joins them all together into one happy family.

------------------------------------------------------------------------

### 1. `select()` works on variables

Let's get started with the first of our dplyr verbs, `select()`.

``` r
select(diabetes, ID, Pregnancies, Glucose)
```

    ## # A tibble: 768 x 3
    ##       ID Pregnancies Glucose
    ##    <dbl> <chr>         <dbl>
    ##  1    32 4-6             148
    ##  2   559 1-3              85
    ##  3   258 7-9             183
    ##  4     5 1-3              89
    ##  5   668 0               137
    ##  6   499 4-6             116
    ##  7   585 1-3              78
    ##  8   539 10+             115
    ##  9   270 1-3             197
    ## 10   214 7-9             125
    ## # ... with 758 more rows

Or, equivalently:

``` r
select(diabetes, ID:Glucose)
```

    ## # A tibble: 768 x 3
    ##       ID Pregnancies Glucose
    ##    <dbl> <chr>         <dbl>
    ##  1    32 4-6             148
    ##  2   559 1-3              85
    ##  3   258 7-9             183
    ##  4     5 1-3              89
    ##  5   668 0               137
    ##  6   499 4-6             116
    ##  7   585 1-3              78
    ##  8   539 10+             115
    ##  9   270 1-3             197
    ## 10   214 7-9             125
    ## # ... with 758 more rows

But be careful with not explicitly referencing variables, and *please* don't do this:

``` r
select(diabetes, 1,2,3)
```

    ## # A tibble: 768 x 3
    ##       ID Pregnancies Glucose
    ##    <dbl> <chr>         <dbl>
    ##  1    32 4-6             148
    ##  2   559 1-3              85
    ##  3   258 7-9             183
    ##  4     5 1-3              89
    ##  5   668 0               137
    ##  6   499 4-6             116
    ##  7   585 1-3              78
    ##  8   539 10+             115
    ##  9   270 1-3             197
    ## 10   214 7-9             125
    ## # ... with 758 more rows

`select()` has a lot of handy tricks:

-   `everything()` to select all variables
-   `-` to drop variables.
-   Use `=` within select to rename variables (*New\_name = Old\_name*)
-   Reposition variables based on their order in `select()`

I want to make Diabetes the first variable in my dataframe:

``` r
select(diabetes, Diabetes, everything())
```

    ## # A tibble: 768 x 10
    ##    Diabetes    ID Pregnancies Glucose BloodPressure SkinThickness Insulin
    ##       <dbl> <dbl> <chr>         <dbl>         <dbl>         <dbl>   <dbl>
    ##  1        1    32 4-6             148            72            35       0
    ##  2        0   559 1-3              85            66            29       0
    ##  3        1   258 7-9             183            64             0       0
    ##  4        0     5 1-3              89            66            23      94
    ##  5        1   668 0               137            40            35     168
    ##  6        0   499 4-6             116            74             0       0
    ##  7        1   585 1-3              78            50            32      88
    ##  8        0   539 10+             115             0             0       0
    ##  9        1   270 1-3             197            70            45     543
    ## 10        1   214 7-9             125            96             0       0
    ## # ... with 758 more rows, and 3 more variables: BMI <chr>,
    ## #   DiabetesPedigreeFunction <dbl>, Age <dbl>

------------------------------------------------------------------------

### 2. `filter()` works on rows

Select works on columns, and `filter()` works on rows.

Some useful logical expressions to refer back to:

Logical expressions are governed by **relational operators**, that output either `TRUE` or `FALSE` based on the validity of the statement you give it. Here's a summary of the operators:

| Operation  | Outputs `TRUE` or `FALSE` based on the validity of the statement... |
|------------|---------------------------------------------------------------------|
| `a == b`   | `a` is equal to `b`                                                 |
| `a != b`   | `a` is not equal to `b`.                                            |
| `a > b`    | `a` is greater than `b`.                                            |
| `a < b`    | `a` is less than `b`.                                               |
| `a >= b`   | `a` is greater than or equal to `b`.                                |
| `a <= b`   | `a` is less than or equal to `b`.                                   |
| `a %in% b` | `a` is an element in `b`.                                           |

(Full credit to [STAT 545](http://stat545.com/) for this handy table)

Let's start by filtering all observations in which blood glucose levels are greater than 100.

``` r
filter(diabetes, Glucose>100)
```

    ## # A tibble: 554 x 10
    ##       ID Pregnancies Glucose BloodPressure SkinThickness Insulin BMI  
    ##    <dbl> <chr>         <dbl>         <dbl>         <dbl>   <dbl> <chr>
    ##  1    32 4-6             148            72            35       0 Obese
    ##  2   258 7-9             183            64             0       0 Norm~
    ##  3   668 0               137            40            35     168 Obese
    ##  4   499 4-6             116            74             0       0 Over~
    ##  5   539 10+             115             0             0       0 Obese
    ##  6   270 1-3             197            70            45     543 Obese
    ##  7   214 7-9             125            96             0       0 Seve~
    ##  8   733 4-6             110            92             0       0 Obese
    ##  9   353 10+             168            74             0       0 Obese
    ## 10   162 10+             139            80             0       0 Over~
    ## # ... with 544 more rows, and 3 more variables:
    ## #   DiabetesPedigreeFunction <dbl>, Age <dbl>, Diabetes <dbl>

How about only data for people who are Obsese?

``` r
filter(diabetes, BMI=="Obese")
```

    ## # A tibble: 430 x 10
    ##       ID Pregnancies Glucose BloodPressure SkinThickness Insulin BMI  
    ##    <dbl> <chr>         <dbl>         <dbl>         <dbl>   <dbl> <chr>
    ##  1    32 4-6             148            72            35       0 Obese
    ##  2   668 0               137            40            35     168 Obese
    ##  3   585 1-3              78            50            32      88 Obese
    ##  4   539 10+             115             0             0       0 Obese
    ##  5   270 1-3             197            70            45     543 Obese
    ##  6   733 4-6             110            92             0       0 Obese
    ##  7   353 10+             168            74             0       0 Obese
    ##  8   386 1-3             189            60            23     846 Obese
    ##  9   533 1-3             103            30            38      83 Obese
    ## 10   164 1-3             115            70            30      96 Obese
    ## # ... with 420 more rows, and 3 more variables:
    ## #   DiabetesPedigreeFunction <dbl>, Age <dbl>, Diabetes <dbl>

Now I want people who are obsese or morbidly obese...

``` r
filter(diabetes, BMI=="Obese" | BMI=="Morbidly Obese")
```

    ## # A tibble: 465 x 10
    ##       ID Pregnancies Glucose BloodPressure SkinThickness Insulin BMI  
    ##    <dbl> <chr>         <dbl>         <dbl>         <dbl>   <dbl> <chr>
    ##  1    32 4-6             148            72            35       0 Obese
    ##  2   668 0               137            40            35     168 Obese
    ##  3   585 1-3              78            50            32      88 Obese
    ##  4   539 10+             115             0             0       0 Obese
    ##  5   270 1-3             197            70            45     543 Obese
    ##  6   733 4-6             110            92             0       0 Obese
    ##  7   353 10+             168            74             0       0 Obese
    ##  8   386 1-3             189            60            23     846 Obese
    ##  9   692 0               118            84            47     230 Morb~
    ## 10   533 1-3             103            30            38      83 Obese
    ## # ... with 455 more rows, and 3 more variables:
    ## #   DiabetesPedigreeFunction <dbl>, Age <dbl>, Diabetes <dbl>

**Exercises**

1.  What's another way to select obese and morbidly obese people?

2.  Filter observations for people who are 25 to 50 years old.

------------------------------------------------------------------------

### 3. `arrange()` changes the order of rows

Okay, now that we've got `select` and `filter()` covered. Let's slip in `arrange()` quickly.

``` r
arrange(diabetes, ID)
```

    ## # A tibble: 768 x 10
    ##       ID Pregnancies Glucose BloodPressure SkinThickness Insulin BMI  
    ##    <dbl> <chr>         <dbl>         <dbl>         <dbl>   <dbl> <chr>
    ##  1     1 0               117             0             0       0 Obese
    ##  2     2 1-3             144            82            46     180 Morb~
    ##  3     3 1-3             155            74            17      96 Over~
    ##  4     4 4-6             125            78            31       0 Over~
    ##  5     5 1-3              89            66            23      94 Over~
    ##  6     6 4-6             125            80             0       0 Obese
    ##  7     7 1-3              90            68             8       0 Norm~
    ##  8     8 10+             126            90             0       0 Obese
    ##  9     9 1-3             119            54            13      50 Norm~
    ## 10    10 0                91            68            32     210 Obese
    ## # ... with 758 more rows, and 3 more variables:
    ## #   DiabetesPedigreeFunction <dbl>, Age <dbl>, Diabetes <dbl>

We can arrange by multiple variables. If you want a variable to be ordered the opposite way, just `desc()`!

Ordered by BMI, and then from oldest to youngest.

``` r
arrange(diabetes, BMI, desc(Age))
```

    ## # A tibble: 768 x 10
    ##       ID Pregnancies Glucose BloodPressure SkinThickness Insulin BMI  
    ##    <dbl> <chr>         <dbl>         <dbl>         <dbl>   <dbl> <chr>
    ##  1   129 0               173            78            32     265 Morb~
    ##  2   260 7-9             171           110            24     240 Morb~
    ##  3   608 4-6             134            80            37     370 Morb~
    ##  4   525 0                67            76             0       0 Morb~
    ##  5     2 1-3             144            82            46     180 Morb~
    ##  6    85 10+             111            84            40       0 Morb~
    ##  7   505 7-9             188            78             0       0 Morb~
    ##  8   673 7-9              81            78            40      48 Morb~
    ##  9   553 10+             103            68            40       0 Morb~
    ## 10    78 10+             135             0             0       0 Morb~
    ## # ... with 758 more rows, and 3 more variables:
    ## #   DiabetesPedigreeFunction <dbl>, Age <dbl>, Diabetes <dbl>

How is arrange handling a categorical variable?

------------------------------------------------------------------------

### 4. `%>%` chains operations together

Alrighty then, now that we've got a few tools, it's time to `%>%`!

The power of piping:

``` r
diabetes %>%
      select(id=ID, Glucose, Diabetes) %>%
        filter(Glucose <= 100) %>%
          arrange(id)
```

    ## # A tibble: 214 x 3
    ##       id Glucose Diabetes
    ##    <dbl>   <dbl>    <dbl>
    ##  1     5      89        0
    ##  2     7      90        0
    ##  3    10      91        0
    ##  4    11     100        0
    ##  5    13     100        1
    ##  6    17      85        0
    ##  7    22      90        1
    ##  8    23      95        0
    ##  9    24      89        0
    ## 10    26      93        0
    ## # ... with 204 more rows

Another example:

``` r
diabetes %>% 
    filter(BMI=="Obese", Age>=50) %>% 
      select(ID, Diabetes) %>% 
        arrange(desc(ID))
```

    ## # A tibble: 45 x 2
    ##       ID Diabetes
    ##    <dbl>    <dbl>
    ##  1   675        1
    ##  2   667        1
    ##  3   643        1
    ##  4   634        1
    ##  5   612        1
    ##  6   601        1
    ##  7   596        1
    ##  8   591        1
    ##  9   583        1
    ## 10   575        1
    ## # ... with 35 more rows

What's happening here? Let's write it down:

-   ...

Now that we're familiar with `%>%`, let's keep using it as we learn our remaining two verbs: `mutate()` and `summarise()`

### Use `mutate()` to create new variables

### We can `summarise()` our data

### Challenge exercises

Let's stop here to give you a chance to play with your new tools.

1.
