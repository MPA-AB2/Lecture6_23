# Lecture6 - OBJECT TRACKING

[**Final Benchmark Results**](https://docs.google.com/spreadsheets/d/1b8PNsH4d6a9KSfeyH94roA728uADy_DA/edit#gid=1879335341)

## Preparation

1. Run Git bash.
2. Set username by: `$ git config --global user.name "name_of_your_GitHub_profile"`
3. Set email by: `$ git config --global user.email "email@example.com"`
4. Select some MAIN folder with write permision.
5. Clone the **Lecture6_23** repository from GitHub by: `$ git clone https://github.com/MPA-AB2/Lecture6_23.git`
6. In the MAIN folder should be new folder **Lecture6_23**.
7. In the **Lecture6_23** folder create subfolder **NAME_OF_YOUR_TEAM**.
8. Run Git bash in **Lecture6_23** folder (should be *main* branch active).
9. Create a new branch for your team by: `$ git checkout -b NAME_OF_YOUR_TEAM`
10. Check that  *NAME_OF_YOUR_TEAM* branch is active.
11. Continue to the task...

## Tasks to do

1. Download the data in a zip folder from [here](https://www.vut.cz/www_base/vutdisk.php?i=311304aa10). Extract the content of the zip folder into **Lecture6_23** folder. It contains folder **Ants** with 215 of *00000XXX.jpg* during time acquired images of Petri dish with 6 ants.
2. Load all images from folder **Ants**.
3. Design and implement an automatic tracking algorithm to track all ants in all images separately.
4. Use the provided MATLAB function for evaluation of the results and submit the output to the provided Excel table. The function *EvaluationAnts.p* called as:
`[errorTracking] = EvaluationAnts(trajectories)`,
has the following inputs and outputs:
  * trajectories (cell array 1x6, where each cell contains matrix for each ant trajectory; matrix should have size 215x2, where the first column indicates the row coordination in the image and the second column of the matrix indicates the column coordinate in the image. It does not matter on the order of the ants.
  * errorTracking (structure containing fields of MAE (mean absolute error for whole dataset), std (standard deviation), MAE_details (details for track errors), and orderAnts (corrected order of the ants).
5. Store your implemented algorithm as a form of function `[trajectories] = TeamName( path )`; for *trajectories* see above; *path* is the path to the **Ants** folder with containing blind dataset of images. The function will be used for evaluation of universality of your solution using another input scenes. **Push** your program implementations into GitHub repository **Lecture6_23** using the **branch of your team** (stage changed -> fill commit message -> sign off -> commit -> push -> select *NAME_OF_YOUR_TEAM* branch -> push -> manager-core -> web browser -> fill your credentials).
6. Submit *.tiff* image of the last image from the sequence with trajectory of all ants obtained by your method. [Excel table](https://docs.google.com/spreadsheets/d/1obMZd9CQdAhPV8WPbLNy62j5S-ujpVxk/edit?usp=sharing&ouid=103992857484835913859&rtpof=true&sd=true). The evaluation of results from each team will be presented at the end of the lecture.
