# INSA Toulouse - 4IR - Caml Project - Ford Fulkerson

Usage: `./launch infile source sink outfile` : to call Ford Fulkerson on a graph

Usage: `./launch infile outfile` : to test the application

Don't write the directory's name, juste the file name. Graph files need to be putted in the graph directory, application files need to be putted in the application one.

# Application

The application compute the best attribution for students and projects based on preferences.
File structure :

```
student id_student "name_student"

project id_project "name_project" max_attribution

choice id_student id_project
```

The students need to be first, then the projects, then the choices.
Id starts from 1.

Example :

```
student 1 "Jean_Paul_Jacques"
student 2 "Jean_Célestin"
student 3 "Jean_Mouloud"
student 4 "Didier_Le_Maître"

project 1 "QLF" 2 
project 2 "ALR" 1
project 3 "GLZ" 1

choice 1 2
choice 1 3

choice 2 1
choice 2 2

choice 3 1
choice 3 2
choice 3 3

choice 4 1
``` 
