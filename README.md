# marks-viewer
Marks in school, college and university are often divided in multiple parts such as assignments projects or exams. Because of this, it is hard to track how well you're doing throughout the year. This terminal app offers an **htop-style** view of the fraction of the mark that you've already earned and the fraction that you've already lost.

Take a look at this example:
![example](https://github.com/user-attachments/assets/8a1d83d4-40bf-46e5-8720-51ae3cc51576)

In **green** you can see the points that you've already earned and in **red** what you've already lost. Finally the part of the graph that has no color is the part that has'nt been assessed yet.

With a quick look you can see that you are doing a very good job in geography but you have to work more on physics. You can also see that in math the big work is already done.

## Usage

This app stores all the data in `.txt` files.
Take a look at this `example.txt`:
```
100
english 100 100 0.2     // Essay
math 7 10 0.3           // Exercises
geography 20 20 0.4     // Exam
english 6 10 0.4        // 1st exam
math 40 40 0.5          // Exam
physics 4 10 0.5        // Project
```
The first line of the file sets the total that will be used to show your marks (10, 100... pi 😉)

The format of the rest of lines is:
```
subject_name mark_out_of_total total weight
```
The `weight` field tells how much this exam counts for the total mark. It is a number between 0 and 1.

These are the mandatory fields, if we add more text on the right it will be ignored so we can use this to write comments as in the example above.

To understand better how the format works let's see an example:

I get a `20` out of `30` in my Math exam. It counts 50% of the final mark. So we have to put in the `weight` field `0.5`. So in our `.txt` file we should write:
```
math 20 30 0.5
```
> [!NOTE]
> You will also need to specify the total that will be used to show your marks at the top of the file


## Running the app
1. To run the app we have to clone the repository:
```sh
git clone https://github.com/danielrouco/marks-viewer
```
2. Compile the code:
```sh
cd marks-viewer
```
```sh
ghc main.hs
```

3. Run the app with the `.txt` file that you are using:
```sh
cat PATH_TO_REPORTS/NAME.txt | PATH_TO_APP/main
```

> [!NOTE]
> Where I write `PATH_TO_APP` I'm referring to the path to the folder that you've just cloned. With `PATH_TO_REPORTS` I'm referring to the path where you put all the reports (`.txt` files) and with `NAME` to the file name without the `.txt` extension.

## Some tips
We've seen that a way to add, edit and remove values is simply to edit the source file. But this can become a little bit tedious, so we can write a few lines of bash to make it easier. For example, we could add these lines to the `.bashrc`:

First, we can write this function that will run the app with the file that we pass as an argument (Note that we pass only the name of the file without the `.txt` extension and for this function to work all the `.txt` files need to be in `PATH_TO_REPORTS`).
```sh
marks(){
    cat PATH_TO_REPORTS/$1.txt | PATH_TO_APP/main
}
```
This function will display the graph view of the file that we pass as an argument. So now if we type `marks example` in the terminal we will get the graph view of the file: `PATH_TO_REPORTS/example.txt`.
```sh
amarks(){
    echo "$2 $3 $4 $5      // $6" >> PATH_TO_REPORTS/$1.txt
}
```
With this other function we can add easily a new mark to the report specified in the 1st argument. For example, if we write `amarks example math 20 30 0.5 exam` this line  `math 20 30 0.5      // exam` will be added to `PATH_TO_REPORTS/example.txt`.
