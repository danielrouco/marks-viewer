# marks-viewer
Marks in school, college and university are often divided in multiple parts such as assignments projects or exams. Because of this, it is hard to track how well you're doing throughout the year. This terminal app offers an **htop-style** view of the fraction of the mark that you've already earned and the fraction that you've already lost.

Take a look at this example:
![example](https://github.com/user-attachments/assets/8a1d83d4-40bf-46e5-8720-51ae3cc51576)

In **green** you can see the points that you've already earned and in **red** what you've already lost. Finally the part of the graph that has no color is the part that has'nt been assessed yet.

With a quick look you can see that you are doing a very good job in geography but you have to work more on physics. You can also see that in math the big work is already done.

## Usage
> [!WARNING]
> This instructions are deprecated. This program no longer works as it is explained below. This section will be updated as soon as possible.

This app stores all the data in `.txt` files.
Take a look at this `example.txt`:
```
english 2 2     // Essay
math 2 3        // Exercises
geography 4 4   // Exam
english 3 4     // 1st exam
math 5 5        // Exam
physics 2 5     // Project
```
The format of this file is:
```
subject_name earned_points total_points
```
These are the mandatory fields, if we add more text on the right it will be ignored so we can use this to write comments as in the example above.

To understand better how the format works let's see an example:

I get a 50 out of 100 in my Math exam. It counts 50% of the final mark. So we have to put our mark out of 5(because the total in this app is 10, so 50% of 10 is 5). That is 2.5 out of 5. So in our `.txt` file we should write:
```
math 2.5 5
```


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

Where I write `PATH_TO_APP` I'm referring to the path to the folder that you've just cloned. With `PATH_TO_REPORTS` I'm referring to the path where you put all the reports (`.txt` files) and with `NAME` to the file name without the `.txt` extension.

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
    echo "$2 $3 $4      // $5" >> PATH_TO_REPORTS/$1.txt
}
```
With this other function we can add easily a new mark to the report specified in the 1st argument. For example, if we write `amarks example math 1.5 2 exam` this line  `math 1.5 2 		// exam` will be added to `PATH_TO_REPORTS/example.txt`.
