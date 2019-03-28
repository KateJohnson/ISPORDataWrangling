Data Wrangling in R for Health Outcomes Research
================

The objective of this workshop is to provide an introduction to data wrangling in R using the tidyverse. By the end of this workshop, you should be able to:

1.  Use a project oriented workflow and an R markdown document.
2.  Perform simple data manipulations using the 5 dplyr verbs (`select`, `filter`, `arrange`, `mutate`, `summarise`, `group_by`), and chain these operations together using piping (`%>%`).
3.  Be aware of the library of `join` functions that allow you to merge datasets together based on a common variable(s).

Objective 1: Setting up our workflow
------------------------------------

First, let's load the [tidyverse](https://www.tidyverse.org/), which is an "an opinionated collection of R packages designed for data science. All packages share an underlying design philosophy, grammar, and data structures." The operate in parallel to, and often in place of, the set of packages included in base R.

``` r
#install.packages("tidyverse")
library(tidyverse)
```

    ## -- Attaching packages ------------------------------------------------------------------------------------- tidyverse 1.2.1 --

    ## v ggplot2 3.1.0       v purrr   0.3.1  
    ## v tibble  2.0.1       v dplyr   0.8.0.1
    ## v tidyr   0.8.3       v stringr 1.4.0  
    ## v readr   1.3.1       v forcats 0.3.0

    ## -- Conflicts ---------------------------------------------------------------------------------------- tidyverse_conflicts() --
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

(Aside: Check out this [this](https://www.tidyverse.org/articles/2017/12/workflow-vs-script/) blogpost by Jenny Bryan about best practices for getting your data into R. *Hint:* if you use code like this: 'rm(list=ls())' she will "set your computer on :fire:.""

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

I want to yoink Diabetes and put it in the very first position in my dataset:

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

**Exercise:**

-   Create a temporary dataframe called *Diab.temp*, with the *Diabetes* variable renamed to *Diab.status* and the *Pregancies* variable dropped.

``` r
Diab.temp <- select(diabetes, -Pregnancies, Diab.status=Diabetes)
```

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

We can negate all these operations by wrapping them in brackets so: `!(a %in% b)` reads `a` is NOT an element in `b`.

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

Now I want people who are obsese or morbidly obese.

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

-   Can you think of another way to select obese and morbidly obese people?

``` r
filter(diabetes, BMI %in% c("Obese","Morbidly Obese"))
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

-   Filter observations for people who are 25 to 50 years old.

``` r
filter(diabetes, Age <=50, Age>= 25)
```

    ## # A tibble: 468 x 10
    ##       ID Pregnancies Glucose BloodPressure SkinThickness Insulin BMI  
    ##    <dbl> <chr>         <dbl>         <dbl>         <dbl>   <dbl> <chr>
    ##  1    32 4-6             148            72            35       0 Obese
    ##  2   559 1-3              85            66            29       0 Over~
    ##  3   258 7-9             183            64             0       0 Norm~
    ##  4   668 0               137            40            35     168 Obese
    ##  5   499 4-6             116            74             0       0 Over~
    ##  6   585 1-3              78            50            32      88 Obese
    ##  7   539 10+             115             0             0       0 Obese
    ##  8   733 4-6             110            92             0       0 Obese
    ##  9   353 10+             168            74             0       0 Obese
    ## 10    13 7-9             100             0             0       0 Over~
    ## # ... with 458 more rows, and 3 more variables:
    ## #   DiabetesPedigreeFunction <dbl>, Age <dbl>, Diabetes <dbl>

-   Exclude observations where the patient has had 10 or more pregnancies.

``` r
filter(diabetes, Pregnancies != "10+")
```

    ## # A tibble: 710 x 10
    ##       ID Pregnancies Glucose BloodPressure SkinThickness Insulin BMI  
    ##    <dbl> <chr>         <dbl>         <dbl>         <dbl>   <dbl> <chr>
    ##  1    32 4-6             148            72            35       0 Obese
    ##  2   559 1-3              85            66            29       0 Over~
    ##  3   258 7-9             183            64             0       0 Norm~
    ##  4     5 1-3              89            66            23      94 Over~
    ##  5   668 0               137            40            35     168 Obese
    ##  6   499 4-6             116            74             0       0 Over~
    ##  7   585 1-3              78            50            32      88 Obese
    ##  8   270 1-3             197            70            45     543 Obese
    ##  9   214 7-9             125            96             0       0 Seve~
    ## 10   733 4-6             110            92             0       0 Obese
    ## # ... with 700 more rows, and 3 more variables:
    ## #   DiabetesPedigreeFunction <dbl>, Age <dbl>, Diabetes <dbl>

------------------------------------------------------------------------

### 3. `arrange()` changes the order of rows

Now that we've got `select` and `filter()` covered. Let's slip in `arrange()` quickly.

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

We can arrange by multiple variables. You can `desc()` too.

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

Alrighty then, now that we've got `select()`, `filter()` and `arrange()`, let's `%>%` them together!

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
      select(ID, Diabetes, BloodPressure) %>% 
        arrange(desc(BloodPressure))
```

    ## # A tibble: 45 x 3
    ##       ID Diabetes BloodPressure
    ##    <dbl>    <dbl>         <dbl>
    ##  1   136        0           108
    ##  2    88        0           106
    ##  3   139        1           104
    ##  4   197        0            95
    ##  5   667        1            94
    ##  6   452        0            92
    ##  7   596        1            92
    ##  8   146        1            92
    ##  9   601        1            90
    ## 10   634        1            90
    ## # ... with 35 more rows

What's happening here? Let's write it down:

-   ...

Now that we're familiar with `%>%`, let's keep using it as we learn our remaining two verbs: `mutate()` and `summarise()`

### Use `mutate()` to create new variables

I want diabetes pedigree function to be expressed as a percentage rather than a proportion.

``` r
diabetes %>% 
  mutate(DiabetesPedigreePercent= DiabetesPedigreeFunction * 100)
```

    ## # A tibble: 768 x 11
    ##       ID Pregnancies Glucose BloodPressure SkinThickness Insulin BMI  
    ##    <dbl> <chr>         <dbl>         <dbl>         <dbl>   <dbl> <chr>
    ##  1    32 4-6             148            72            35       0 Obese
    ##  2   559 1-3              85            66            29       0 Over~
    ##  3   258 7-9             183            64             0       0 Norm~
    ##  4     5 1-3              89            66            23      94 Over~
    ##  5   668 0               137            40            35     168 Obese
    ##  6   499 4-6             116            74             0       0 Over~
    ##  7   585 1-3              78            50            32      88 Obese
    ##  8   539 10+             115             0             0       0 Obese
    ##  9   270 1-3             197            70            45     543 Obese
    ## 10   214 7-9             125            96             0       0 Seve~
    ## # ... with 758 more rows, and 4 more variables:
    ## #   DiabetesPedigreeFunction <dbl>, Age <dbl>, Diabetes <dbl>,
    ## #   DiabetesPedigreePercent <dbl>

**Exercises:**

-   Make a new variable called *GlucoseDiff*, which equals the difference between each patient's glucose level and the average glucose level for all patients. Then reduce the dataset to only the *ID*, *Glucose*, and *GlucoseDiff* variables.

``` r
diabetes %>% 
    mutate(GlucoseDiff= Glucose - mean(Glucose)) %>% 
      select(ID, Glucose, GlucoseDiff)
```

    ## # A tibble: 768 x 3
    ##       ID Glucose GlucoseDiff
    ##    <dbl>   <dbl>       <dbl>
    ##  1    32     148       27.1 
    ##  2   559      85      -35.9 
    ##  3   258     183       62.1 
    ##  4     5      89      -31.9 
    ##  5   668     137       16.1 
    ##  6   499     116       -4.89
    ##  7   585      78      -42.9 
    ##  8   539     115       -5.89
    ##  9   270     197       76.1 
    ## 10   214     125        4.11
    ## # ... with 758 more rows

-   Filter the dataset to include only patients with insulin level not equal to 0, and then create a new variable called *GI.Ratio* that gives the ratio of their glucose to insulin levels

``` r
diabetes %>% 
  filter(Insulin > 0) %>% 
    mutate(GI.Ratio = Glucose/Insulin)
```

    ## # A tibble: 394 x 11
    ##       ID Pregnancies Glucose BloodPressure SkinThickness Insulin BMI  
    ##    <dbl> <chr>         <dbl>         <dbl>         <dbl>   <dbl> <chr>
    ##  1     5 1-3              89            66            23      94 Over~
    ##  2   668 0               137            40            35     168 Obese
    ##  3   585 1-3              78            50            32      88 Obese
    ##  4   270 1-3             197            70            45     543 Obese
    ##  5   386 1-3             189            60            23     846 Obese
    ##  6   155 4-6             166            72            19     175 Over~
    ##  7   692 0               118            84            47     230 Morb~
    ##  8   533 1-3             103            30            38      83 Obese
    ##  9   164 1-3             115            70            30      96 Obese
    ## 10   253 1-3             126            88            41     235 Obese
    ## # ... with 384 more rows, and 4 more variables:
    ## #   DiabetesPedigreeFunction <dbl>, Age <dbl>, Diabetes <dbl>,
    ## #   GI.Ratio <dbl>

### We can `summarise()` our data

Our last verb is used to create aggregated summarises our data. It is especially helpful when used in conjuction with `group_by()`

Let's start with some counting. The `n()` function is good for this.

How many people do we have in each BMI category?

``` r
diabetes %>% 
    group_by(BMI) %>% 
      summarise(number = n())
```

    ## # A tibble: 6 x 2
    ##   BMI                  number
    ##   <chr>                 <int>
    ## 1 Morbidly Obese           35
    ## 2 Normal                  108
    ## 3 Obese                   430
    ## 4 Overweight              180
    ## 5 Severely underweight     11
    ## 6 Underweight               4

FYI: You could also pipe to `tally()` which is equivalent to `summarise(n())` here.

Let's see if there might be some relation betwen BMI and age, by calculating the average age and standard deviation within each BMI category.

``` r
diabetes %>% 
  group_by(BMI) %>% 
    summarise(AverageAge= mean(Age), SDAge= sd(Age))
```

    ## # A tibble: 6 x 3
    ##   BMI                  AverageAge SDAge
    ##   <chr>                     <dbl> <dbl>
    ## 1 Morbidly Obese             33.3  9.54
    ## 2 Normal                     32.0 13.4 
    ## 3 Obese                      33.8 11.0 
    ## 4 Overweight                 33.0 12.6 
    ## 5 Severely underweight       30.5 15.9 
    ## 6 Underweight                24    3.46

Now I want to know the average age *and* the proportion of people with diabetes in each BMI category.

``` r
diabetes %>% 
  group_by(BMI, Diabetes) %>% 
    summarise(AverageAge= mean(Age), Number = n()) %>% 
      mutate(Prop= Number/sum(Number))
```

    ## # A tibble: 11 x 5
    ## # Groups:   BMI [6]
    ##    BMI                  Diabetes AverageAge Number   Prop
    ##    <chr>                   <dbl>      <dbl>  <int>  <dbl>
    ##  1 Morbidly Obese              0       32.5     13 0.371 
    ##  2 Morbidly Obese              1       33.7     22 0.629 
    ##  3 Normal                      0       31.1    101 0.935 
    ##  4 Normal                      1       44.3      7 0.0648
    ##  5 Obese                       0       31.3    237 0.551 
    ##  6 Obese                       1       36.9    193 0.449 
    ##  7 Overweight                  0       31.4    136 0.756 
    ##  8 Overweight                  1       37.9     44 0.244 
    ##  9 Severely underweight        0       27.9      9 0.818 
    ## 10 Severely underweight        1       42        2 0.182 
    ## 11 Underweight                 0       24        4 1

**Exercises:**

-   What is the proportion of patients with glucose over 120 that have diabetes? Hint: You can use a continous variable as a grouping factor

``` r
diabetes %>% 
    group_by(Glucose >120, Diabetes) %>% 
      summarise(Number=n()) %>% 
        mutate(Prop= Number/sum(Number))
```

    ## # A tibble: 4 x 4
    ## # Groups:   Glucose > 120 [2]
    ##   `Glucose > 120` Diabetes Number  Prop
    ##   <lgl>              <dbl>  <int> <dbl>
    ## 1 FALSE                  0    346 0.826
    ## 2 FALSE                  1     73 0.174
    ## 3 TRUE                   0    154 0.441
    ## 4 TRUE                   1    195 0.559

### Challenge exercises

Your turn!

Your mission is to determine which characteristic (or set of characteristics) differs the most between diabetic and non-diabetic patients. We'll flag these variables as being potentially important to include in a future predictive model.

-   **(Task 1)** Let's start by picking a few variables that you expect to differ a lot based on diabetes status (and at least one that's continuous, and one that's categorical), and then use a staistic of your choice (for example: mean, median, proportion) to summarise that variable across diabetes categories.

*For example, you could calculate the average age, blood pressure, and glucose level among diabetic and non-diabetic patients. In a seperate pipe operation, you could do the same for the proportion of people in each of the pregnancy categories.*

``` r
# Continuous variables
diabetes %>% 
  group_by(Diabetes) %>% 
    summarise(AverageAge=mean(Age), AverageBP=mean(BloodPressure), AverageGlucose= mean(Glucose))
```

    ## # A tibble: 2 x 4
    ##   Diabetes AverageAge AverageBP AverageGlucose
    ##      <dbl>      <dbl>     <dbl>          <dbl>
    ## 1        0       31.2      68.2           110.
    ## 2        1       37.1      70.8           141.

``` r
# Categorical variable
diabetes %>% 
  select(ID, Pregnancies, BMI, Diabetes) %>% 
    group_by(Diabetes, Pregnancies) %>% 
      summarise(n=n()) %>% 
        mutate(prop= round(n/sum(n),2)) %>% 
          arrange(Pregnancies)
```

    ## # A tibble: 10 x 4
    ## # Groups:   Diabetes [2]
    ##    Diabetes Pregnancies     n  prop
    ##       <dbl> <chr>       <int> <dbl>
    ##  1        0 0              73  0.15
    ##  2        1 0              38  0.14
    ##  3        0 1-3           238  0.48
    ##  4        1 1-3            75  0.28
    ##  5        0 10+            28  0.06
    ##  6        1 10+            30  0.11
    ##  7        0 4-6           115  0.23
    ##  8        1 4-6            60  0.22
    ##  9        0 7-9            46  0.09
    ## 10        1 7-9            65  0.24

We have a bit of a problem with units of the continuous variables, don't we? It would be much better if we could express glucose and blood pressure in the same units so that they would be comparable. Let's try to do that using the `scale()` function.

-   **(Task 2)** Choose a subset of (continous) variables of interest, scale them, and then calculate the difference between diabeties categories using this new, scaled variable. Which variable differs the most between diabetic and non-diabetic patients?

``` r
diabetes %>% 
    mutate(z.Age=scale(Age), z.BP=scale(BloodPressure), z.Glucose= scale(Glucose)) %>% 
      group_by(Diabetes) %>% 
        summarise(AverageAge=mean(z.Age), AverageBP=mean(z.BP), AverageGlucose= mean(z.Glucose)) %>%
  # optional final step to reshape the data
          gather(key="Predictor", value="Z.mean", AverageGlucose:AverageAge)
```

    ## # A tibble: 6 x 3
    ##   Diabetes Predictor       Z.mean
    ##      <dbl> <chr>            <dbl>
    ## 1        0 AverageGlucose -0.341 
    ## 2        1 AverageGlucose  0.637 
    ## 3        0 AverageBP      -0.0476
    ## 4        1 AverageBP       0.0888
    ## 5        0 AverageAge     -0.174 
    ## 6        1 AverageAge      0.325

-   **(Task 3)** **Bonus:** (For the experienced data wrangler) Do the same as question 2, but this time, scale all the continous variables in the same step, and (in another step) calculate the difference in their means between diabetes groups. Try to do this **without** explicitly calling the variable names.

You may find the conditional functions `select_if()`, `mutate_at()` and `summarise_at()` very helpful here, because there are some continous variables (ie. ID and Diabetes status), you won't want to scale.

``` r
diabetes %>% 
    select_if(is.numeric) %>% 
      mutate_at(vars(-ID,-Diabetes), scale) %>% 
        group_by(Diabetes) %>% 
          summarise_at(vars(-ID), mean) %>% 
# you could stop here, but it's hard to compare the difference between groups with the variables spread 
# out like this, and even harder to plot, so let's gather them
            gather(key="Predictor", value="Z.mean", Glucose:Age) %>%
              group_by(Predictor) %>% 
                mutate(delta.z.mean= Z.mean - lag(Z.mean,1))
```

    ## # A tibble: 12 x 4
    ## # Groups:   Predictor [6]
    ##    Diabetes Predictor                 Z.mean delta.z.mean
    ##       <dbl> <chr>                      <dbl>        <dbl>
    ##  1        0 Glucose                  -0.341        NA    
    ##  2        1 Glucose                   0.637         0.978
    ##  3        0 BloodPressure            -0.0476       NA    
    ##  4        1 BloodPressure             0.0888        0.136
    ##  5        0 SkinThickness            -0.0547       NA    
    ##  6        1 SkinThickness             0.102         0.157
    ##  7        0 Insulin                  -0.0955       NA    
    ##  8        1 Insulin                   0.178         0.274
    ##  9        0 DiabetesPedigreeFunction -0.127        NA    
    ## 10        1 DiabetesPedigreeFunction  0.237         0.364
    ## 11        0 Age                      -0.174        NA    
    ## 12        1 Age                       0.325         0.500

``` r
# Now we can see that the greatest (standardized) difference is in Glucose
```

------------------------------------------------------------------------

Objective 3: Joining datasets
-----------------------------

Dplyr has a set of join functions that allow you to merge datasets together based on a commmon variable(s). If you speak SQL, stop here! These are just the standard SQL joins implemented in R. If you don't, check out this very [handy cheatsheet](https://stat545.com/bit001_dplyr-cheatsheet.html) courtesy of Jenny Bryan that describes all the available join functions and what they do. Below, we'll go through a sample workflow when we have a primary dataset and want to link in additional information from another dataset.

We'll stick with diabetes as our primary dataset, but now we have another dataset, *Diabetes\_extra*, which contains additional variables that we want to link in. The ID variable was used to identify individuals in both datasets. (**Disclosure:** I made this data up.)

``` r
diabetes_extra <- read_csv(here("Data/diabetes_extra.csv"))
```

    ## Parsed with column specification:
    ## cols(
    ##   ID = col_double(),
    ##   Cholesterol = col_double(),
    ##   FamilyHistory = col_double(),
    ##   ActivityLevel = col_double()
    ## )

The first thing we want to know is whether *Diabetes\_extra* contains the full set of IDs found in *Diabetes*. This is important because if we start introducing NAs into our data, we want to understand why. Luckily, a join can help us wth this.

The `anti_join` returns all rows from dataset 1 that are not in dataset 2.

``` r
anti_join(diabetes, diabetes_extra, by="ID")
```

    ## # A tibble: 8 x 10
    ##      ID Pregnancies Glucose BloodPressure SkinThickness Insulin BMI  
    ##   <dbl> <chr>         <dbl>         <dbl>         <dbl>   <dbl> <chr>
    ## 1     8 10+             126            90             0       0 Obese
    ## 2    35 0               131             0             0       0 Obese
    ## 3   299 7-9             102            74            40     105 Obese
    ## 4   690 1-3             112            68            22      94 Obese
    ## 5   331 1-3             115            64            22       0 Obese
    ## 6   477 4-6             129            90             7     326 Norm~
    ## 7   360 1-3             130            64             0       0 Norm~
    ## 8   175 7-9             154            78            32       0 Obese
    ## # ... with 3 more variables: DiabetesPedigreeFunction <dbl>, Age <dbl>,
    ## #   Diabetes <dbl>

There are 8 IDs that are in *diabetes* but not in *diabetes\_extra*. Let's store these "missing" IDs in a variable so we can see what happens to them when we join the datasets.

``` r
missingIDs <- anti_join(diabetes, diabetes_extra, by="ID") %>% 
                        select(ID)

# store the missing IDs as a vector rather than a dataframe
missingIDs <- as.vector(missingIDs$ID) 
```

My go to is the `left_join` because it returns all rows from dataset 1 no matter what's in dataset 2, and I really don't want to be losing patients in my master dataset accidently. By default, `left_join` adds all columns from dataset 2 to dataset 1, but if we didn't want that, we could first use `select` on dataset 2 to get only the variables we want, and then `%>%` to a `left_join`.

``` r
left_join(diabetes, diabetes_extra, by="ID") %>% 
      select(ID, BloodPressure, BMI, Cholesterol, FamilyHistory, ActivityLevel) %>% 
          arrange(ID)
```

    ## # A tibble: 768 x 6
    ##       ID BloodPressure BMI          Cholesterol FamilyHistory ActivityLevel
    ##    <dbl>         <dbl> <chr>              <dbl>         <dbl>         <dbl>
    ##  1     1             0 Obese                197             0             4
    ##  2     2            82 Morbidly Ob~         215             1             1
    ##  3     3            74 Overweight           231             0             2
    ##  4     4            78 Overweight           277             0             2
    ##  5     5            66 Overweight           181             0             2
    ##  6     6            80 Obese                249             0             4
    ##  7     7            68 Normal               135             1             2
    ##  8     8            90 Obese                 NA            NA            NA
    ##  9     9            54 Normal               188             0             2
    ## 10    10            68 Obese                215             0             5
    ## # ... with 758 more rows

``` r
# store this to a dataframe of the same name
diabetes <- left_join(diabetes, diabetes_extra, by="ID")
```

There we have it! Now patient cholesterol, family history, and activity level are added to the *diabetes* dataset - which now has 13 variables instead of 10. But let's see what happened to our missing observations.

``` r
diabetes %>% 
    filter(ID %in% missingIDs) %>% 
      select(ID, Cholesterol, FamilyHistory, ActivityLevel)
```

    ## # A tibble: 8 x 4
    ##      ID Cholesterol FamilyHistory ActivityLevel
    ##   <dbl>       <dbl>         <dbl>         <dbl>
    ## 1     8          NA            NA            NA
    ## 2    35          NA            NA            NA
    ## 3   299          NA            NA            NA
    ## 4   690          NA            NA            NA
    ## 5   331          NA            NA            NA
    ## 6   477          NA            NA            NA
    ## 7   360          NA            NA            NA
    ## 8   175          NA            NA            NA

The IDs that weren't in *diabetes\_extra* have been retained in *diabetes*, but the new variables were assigned NA for those observations. That seems about right seeing as they really were missing, but if we wanted, we could replace the NAs with another value, how about we call them "missing" instead. `replace_na` is part of the tidy family.

``` r
diabetes %>% 
    replace_na(list(Cholesterol="missing", FamilyHistory="missing", ActivityLevel="missing")) %>% 
       filter(ID %in% missingIDs) %>% 
            select(ID, Cholesterol, FamilyHistory, ActivityLevel)
```

    ## # A tibble: 8 x 4
    ##      ID Cholesterol FamilyHistory ActivityLevel
    ##   <dbl> <chr>       <chr>         <chr>        
    ## 1     8 missing     missing       missing      
    ## 2    35 missing     missing       missing      
    ## 3   299 missing     missing       missing      
    ## 4   690 missing     missing       missing      
    ## 5   331 missing     missing       missing      
    ## 6   477 missing     missing       missing      
    ## 7   360 missing     missing       missing      
    ## 8   175 missing     missing       missing

**That's it!** :clap: :clap: I hope this workshop helped to make R something that makes your life easier rather than harder (and is *maybe* even just a little bit fun :wink:).

------------------------------------------------------------------------

**Extras:** Some other verbs that are part of the tidyverse and therefore very `%>%`able:

-   `count()`: very similar to `table()` from base R.
-   `rename()`: rename a variable (same as using = in `select()`)
-   `slice()`: reference rows to keep (or drop)
-   `lag()`: lag a row x number of times
-   `first()`: select the first row (in a group for example)
-   `rowwise()`: the opposite of `group_by()`
