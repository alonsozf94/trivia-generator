# CLIvia generator

## Start the program

When the program starts, we will initialize the scores filename, the array of
questions, and the user's score.

The filename value is `scores.json` by default, but the user can pass a custom
filename as a command-line argument. For example
`ruby clivia_generator.rb custom_scores.json`

```
ruby clivia_generator.rb
###################################
#   Welcome to Clivia Generator   #
###################################
random | scores | exit
>
```

- Error message when invalid option: "Invalid option"

## When "random" is selected

You should load **10** random questions from the API. Once they are loaded you
will show each of them **one by one**, allowing the user to select one of the
options.

Answers could come encoded with some special characters, use the
[HTMLEntities](https://www.rubydoc.info/gems/htmlentities/4.3.2/HTMLEntities)
gem to decode it, and show the text as expected.

```
###################################
#   Welcome to Clivia Generator   #
###################################
random | scores | exit
> random
Category: History | Difficulty: medium
Question: What was the capital of South Vietnam before the Vietnam War?
1. Ho Chi Minh City
2. Hue
3. Saigon
4. Hanoi
> 
```

The base_uri of the request is https://opentdb.com/, need more detail
on the API? Look at [here](https://opentdb.com/api_config.php)

Once the user gives an answer you should compare it with the correct answer
delivered by the API. Then give the user a correct or incorrect response
message. If the user's answer was incorrect, you will show the correct answer.
Finally, if the user's answer was correct we will increase their score by 10.

```
...
Category: History | Difficulty: medium
Question: What was the capital of South Vietnam before the Vietnam War?
1. Ho Chi Minh City
2. Hue
3. Saigon
4. Hanoi
> 1
Ho Chi Minh City... Incorrect!
The correct answer was: Saigon
```

Then, continue showing the next questions you reach the end of the questions
array.

```
...
> 1
Ho Chi Minh City... Incorrect!
The correct answer was: Saigon
Category: Entertainment: Musicals & Theatres | Difficulty: hard
Question: In Les Misérables, who is Prison Code 24601?
1. Javert
2. Jean Claude Van Damme
3. Jean Valjean
4. Marius Pontmercy
>
```

Once we get to the end of the questions, we will show the message
`Well done! Your score is {score}` and then we will prompt the user to persist
the score.

```
...
September 2nd, 1945... Incorrect!
The correct answer was: May 9th, 1945
Category: Entertainment: Video Games | Difficulty: medium
Question: In the Resident Evil series, Leon S. Kennedy is a member of STARS.
1. True
2. False
> 1
True... Incorrect!
The correct answer was: False
Well done! Your score is 30
--------------------------------------------------
Do you want to save your score? (y/n)
```

If user types `n` or `N`, then the program will go back to the actions menu

```
...
Well done! Your score is 30
--------------------------------------------------
Do you want to save your score? (y/n)
> n
###################################
#   Welcome to Clivia Generator   #
###################################
random | scores | exit
>
```

- Error message when invalid option: "Invalid option"

If the user types `y` or `Y`, then the program will prompt the user to assign a
name to the score.

Once the name is given by the user, we will append the recent score to the file
pointed by the filename we declared at initialization, **this file should be a
JSON and should start empty**.

In case the user didn't type a name, we will add the score as `"Anonymous"` to
the scores' file.

Finally, show back the welcome message with the options menu.

```
...
Well done! Your score is 30
--------------------------------------------------
Do you want to save your score? (y/n)
> y
Type the name to assign to the score
> Codeable
###################################
#   Welcome to Clivia Generator   #
###################################
random | scores | exit
>
```

<aside> 💡 In case you are using JSON.parse within `File.read` to grab scores
data from the declared file, rescue `Errno::ENOENT` to take care of the error
when the file is empty to be able to keep going. </aside>

## When scores action is selected

Last but not least, when scores action is selected you should show the scores
that were saved previously, these scores should be shown in order from top to
bottom and inside a table that includes the title `Top Scores`, and the headings
`Name` ****and `Score`.

Once the table is shown, we will prompt the user with the welcome menu again so
they can keep going with another Clivia.

```
...
###################################
#   Welcome to Clivia Generator   #
###################################
random | scores | exit
> scores
+-----------+-------+
|    Top Scores     |
+-----------+-------+
| Name      | Score |
+-----------+-------+
| Deyvi     | 40    |
| Diego     | 40    |
| Wences    | 30    |
| Anonymous | 20    |
+-----------+-------+
###################################
#   Welcome to Clivia Generator   #
###################################
random | scores | exit
>
```
