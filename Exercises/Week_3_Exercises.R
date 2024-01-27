##### Week 3 Excercises ####

# 01: Vectors ####
## Excercise 1 ####

x <- c(4,6,5,7,10,9,4,15)
x<7 # A 

## Excercise 2 ####
p <- c(3,5,6,8)
q <- c(3,3,3)
p+q # I can't tell if the answer is e. or d. I think e 

## Excercise 3 ####
a = c(1,3,4,7,10,0)
b = c(1,2)
# what is the value of a+b ?
a+b # weird output 
sum(a) + sum(b)

## Excercise 4 ####
z <- 0:9
digits <- as.character(z)
integers <- as.integer(digits)
is.vector(digits)
class(digits)

# Exercise 5 ####
x <- c(1,2,3,4)
(x+2)[(!is.na(x)) & x > 0] -> k # WHAT THE FUCK IS THIS 
# the answer is 3, 4, 5, 6. But what the fuck. Okay chatgpt helped me figure it out


## Exercise 6 ####
#Consider the following vectors:
s <- c("a","b","c","d","e")
t <- c("f","g","h","i","j")
# What is the value of s+3 ?
s+3 # Error: non-numeric argument to binary operator 
# What command would you use to combine them into a single vector in alphabetical order?
u <- c(s,t)
u

## Exercise 7 ####
s <- c("a","b","c","d","e")
v <- 1:5
z <- c(s,v)
# What is the value of z[5:10]?
z[5:10]
#turned them all into character vectors 

# 02: Regular Sequences ####

## 1 ####
seq(1,10,by=2)
seq(1,10,by=3)

## 2 ####
seq(9,50,by=9)

## 3 ####
seq(1,10,length.out = 5)
seq(1,10,length.out=3)

## 4 #####
x <- 1:5
rep(x,2)
rep(x,2,each=2)
rep(x,each=4)

## 5 ####
x <- "Hip"
y <- "Hooray"
rep(c(rep(x,2),y),3)

## 6 ####
seq(100, 50, by = -5)

## 7 ####
Semester_Start <- as.Date("2019-08-19") 
Semester_End <- as.Date("2019-12-05") 
seq(Semester_Start,Semester_End,by="week")
midterm <- seq(Semester_Start,Semester_End,length.out=3)[2]
