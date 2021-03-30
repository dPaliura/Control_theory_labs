# control_theory_labs

Languages: [EN](#EN) | [UA](#UA) | [RU](#RU)

## EN

This repo was created for holding laboratory works for the subject "Control Theory",
which were accomplished by **Daniel Paliura** - student of KM-73 group 
(2017-2021 study years) of NTUU "Igor Sikorsky KPI".

Contents:  
* [Laboratory work 1](#laboratory-work-1)
  'Navigation Problem of Speed' - folder
  [lab1](https://github.com/dPaliura/Control_theory_labs/tree/main/lab1)
* [Laboratory work 2](#laboratory-work-2)
  'Mathematical Modeling of Epidemics' - folder
  [lab2](https://github.com/dPaliura/Control_theory_labs/tree/main/lab2)
* [Laboratory work 3](#laboratory-work-3)
  'Numerical Solution of a Variation Problem' - folder
  [lab3](https://github.com/dPaliura/Control_theory_labs/tree/main/lab3)

### Laboratory work 1

The task of this work is to find control of boat which moves on a plane from
point
(0, 0) to some stable target with speed v. There is a vector field of the stream
on a plane. The vector of the stream is parallel to abscissa and perpendicular
to ordinate in each plane point. Speed of stream is dependent of y coordinate
and expressed as
s(y) = s0 * f(y), 
where s0 - initial speed of stream (on abscissa axis), f(y) - some function, for
example, f(y) = sin(y). Target point defined in Polar Coordinate system with
next parameters:
l - distance to the target from the origin,
phi - the angle between the abscissa axis and vector from the origin to target.
v, s0, l, phi, f(y) - problem parameters. It is set to solve the problem with
the aiming method.

Laboratory work task includes research of problem parameters influence. The
research was made and it was proposed an alternative algorithm of the problem
solution. The proposed algorithm was compared to the aiming method.
File in directory lab1
[research.pdf](https://github.com/dPaliura/Control_theory_labs/blob/main/lab1/research.pdf)
contains full research of parameters, target reach conditions formulation and
proof, proposed algorithm formulation and implementation with R language.

Program developed with R language (R version 4.0.4) in RStudio Desktop 
environment under Ubuntu 20.4.

To run the program you need to run script main.R inside the lab1 folder.
Other scripts must be in the same folder as main.R script.

The result of program run contains a description of input data, description of
key model variables, and plot with boat movement to the target.

One great issue of this problem solution is the used method. It is not always 
achievable target will be reached with the used method. For example, in my
variant where parameters are set as:
s0 = sqrt(n), v = sqrt(n), l = n, phi = n*pi/25, f(y) = y; 
n = 15 - the student's number in group list.
Stream blows boat to the side when it approaches to target by vertical.
Given method does not work when n > 2. But it is solvable because f(y) could be
used to move around to be blown to the target side by the stream direction
afterward.

The developed program foresees two ways of data input:
+ By default - input data according to the variant with n = 15
+ By hand - each parameter must be entered by the user through the console.
  And it is available to use R language: you can use built-in functions as
  cos(), exp(), sqrt(), log() and other mathematical functions and expressions.
  It is needed to be evaluated as numbers.
Also, the program is restartable. After model compilation and interpretation,
the user is asked to restart the program.

### Laboratory work 2

This work is dedicated for modeling of epidemics evolution. This work has no
interactive program part for difference to first one, and developed software
tools are for building and computing the model and also for displaying it
(descriptive text and plotting), those tools are divided into two modules.
Chosen model has name SIRD and it based on differential equations system with
variables describing volumes of different groups of people:

* S - Susceptible,
* I - Infected,
* R - Recovered,
* D - Dead.

This model has many different complications. Such one I used in this work. Built
model includes testing for infection, so it has additional group J - tested
infected. People in this group are isolated from contacts with Susceptible and
have chances to recover not less than Infected (latent) and death probability
not greater than Infected.

Model parameters are:

* N - whole number of people
* I0 - initial number of infected (I0 > 0 with t=0)
* r - mean contacts intensity for single individual while day
* c - mean probability to infect after one contact with one infected
* alpha - mean probability to recover while a day for latent infected I
* beta - mean probability to die while a day for latent infected I
* a - mean probability to recover while a day for tested infected J (a >= alpha)
* b - mean probability to die while a day for tested infected J (b <= beta)

Also model has control variables - tested part for each day and analogue for
vaccinated part. Vaccinated people becomes Recovered at once.

In this work it was made a research for model the flow dependence on model
parameters. Control affect was considered too.
File
[research.pdf](https://github.com/dPaliura/Control_theory_labs/blob/main/lab2/research.pdf)
contains full model description and mentioned research.

### Laboratory work 3

The last laboratory work studies the numerical solution of a variation problem.
This problem consists in approximation of a smooth function by N+1 points. This
smooth function optimizes goal function integral on time interval with fixed
bounds and fixed bound coordinates.
File
[report.pdf](https://github.com/dPaliura/Control_theory_labs/blob/main/lab3/report.pdf)
contains more complete and correct formulation for the Variation Problem, also,
the task for laboratory work and its performance.

Solution for such a problem could be used in first and second works to find
optimal controls.

For task performance, a module was developed which contains function that solves
a variation problem and returns solution as special class object, and so pair of
generic functions was written for this class:

* summary - for the text interpretation of solution,
* plot - for plotting solution.

The developed program isn't interactive, but is pretty comfortable and clear for
use, also lets customize parameters of problem and optimization method used in
solution.


## UA

Цей репозиторій створено для збереження лабораторних робіт з предмету
"Теорія Керування" , що виконав **Палюра Данило Валерійович** - студент групи 
КМ-73 (2017-2021 навчальні роки) НТУУ "КПІ ім. Ігоря Сікорського". 

Зміст:  
* [Лабораторна робота 1](#лабораторна-робота-1)
  'Навігаційна задача швидкодії' - папка 
  [lab1](https://github.com/dPaliura/Control_theory_labs/tree/main/lab1)
* [Лабораторна робота 2](#лабораторна-робота-2)
  'Математичне моделювання епідемій' - папка
  [lab2](https://github.com/dPaliura/Control_theory_labs/tree/main/lab2)
* [Лабораторна робота 3](#лабораторна-робота-3)
  'Чисельне розв'язання Варіаційної задачі' - папка
  [lab3](https://github.com/dPaliura/Control_theory_labs/tree/main/lab3)

### Лабораторна робота 1

В даній лаборатрній роботі поставлена задача знайти керування кораблем, що
рухається на площині із точки (0, 0) до деякої заданої цільової точки із 
швидкістю v. При цьому на площині задано векторне поле течії, вектор напрямку 
якої в довільній точці паралельний осі абсцис і перпендикулярний осі ординат. 
Швидкість течії залежить від координати y і має вигляд s(y) = s0 * f(y),
де s0 - початкова швидкість течії (на осі абсцис), f(y) - функція, наприклад, 
f(y) = sin(y). Точка цілі задається в полярній системі координат параметрами
l - відстань до цілі від початку координат,
phi - кут між віссю абсцис та вектором, що сполучає початкову точку корабля та
    точку цілі.
v, s0, l, phi, f(y) - параметри задачі. Задачу поставлено вирішувати методом 
прицілювання.

Також поставлено задачу дослідити вплив параметрів описаної задачі. Дослідження
було проведено і також було запропоновано альтернативний алгоритм.
Запропонований алгоритм було порівняно із методом прицілювання.
Файл
[research.pdf](https://github.com/dPaliura/Control_theory_labs/blob/main/lab1/research.pdf)
в директорії lab1 містить повне дослідження, формулювання та
доведення умов досяжності цільової точки, запропонований алгоритм та його
реалізацію на мові R.

Розроблена програма написана мовою програмування R (R version 4.0.4).
Розроблена в середовищі RStudio Desktop в операційній системі Ubuntu 20.4.

Для запуску програми необхідно виконати скрипт main.R, розміщений в папці lab1.
Інші скрипти цієї папки мають знаходитись у тій самій папці, що і main.R.

Результатом виконання програми є опис введених даних, опис основних змінних
моделі та графік, на якому зображено траекторію руху корабля.

Проблемою поставленої задачі є використовуваний метод. Не завжди, коли цільова
точка є досяжною фактично, метод дає рішення задачі. Таким прикладом є мій 
варіант, в якому задані наступні параметри задачі:
s0 = sqrt(n), v = sqrt(n), l = n, phi = n*pi/25, f(y) = y; 
n = 15 - номер студента в списку групи. 
Фактично при таких параметрах задача не вирішується розробленою моделлю при 
n > 2, оскільки має місце знос корабля при наближенні до точки по горизонталі.
Але очевидно задача є вирішуваною при таких умовах. Спочатку кораблю слід 
обігнути цільову точку так, щоб, із урахуванням майбутнього зносу, він рухався 
до цілі за течією.

В розробленій програмі передбачено 2 варіанти вводу даних:
+ За замовчуванням - вводяться дані згідно варіанту для n = 15
+ Ручне введення - всі параметри вводяться користувачем вручну через консольний
  запит. При цьому дозволяється використання всіх можливостей мови R: можна
  використовувати вбудовані математичні функціх такі, як cos(), exp(), sqrt(),
  log() та інші математичні функції мови та вирази, головне, щоб вони повертали
  числові значення.
Також програма передбачає повторне виконання. Після побудови та інтерпретації
моделі користувачу пропонується виконати програму ще раз.

### Лабораторна робота 2

Ця робота присвячена моделюванню розвитку епідемій. На відміну від першої 
роботи, в цій роботі відсутня інтерактивна частина програми, а розроблені 
програмні засоби для створення і прорахунку моделі, а також для відображення
(текстового опису та побудови графіків); ці засоби розділені на 2 модулі.
Застосована модель називається SIRD та базується на системі диференціальних
рівнянь із змінними, що відображають кількість людей в різних групах:

* S - Susceptible, кількість здорових людей,
* I - Infected, кількість інфікованих людей,
* R - Recovered, кількість людей з імунітетом,
* D - Dead, кількість людей, що померли.

Ця модель має багато різноманітних ускладнень. В даній роботі було реалізовано
саме одне з таких ускладнень. Побудована модель враховує тестування населення,
тобто додається ще одна група людей - J, для якої вважається, що люди з цієї
групи ізольовані від контактів з іншими людьми та мають шанси виздоровлення не
менші, ніж у латентно хворих (група I) та не більшу ймовірність смерті, ніж у
латентно хворих.

Параметрами моделі є:

* N - загальна кількість людей
* I0 - початкова кількість хворих (I0 > 0 при t=0)
* r - середня інтенсивність контактів одного індивіда за день
* c - середня ймовірність заразитись при конткті із хворим
* alpha - середня ймовірність виздоровити за один день для латентного хворого
* beta - середня ймовірність померти за один день для латентного хворого
* a - середня ймовірність виздоровити за один день для тестованого хворого
  (a >= alpha)
* b - середня ймовірність померти за один день для тестованого хворого
  (b <= beta)

Також модель передбачає змінні контролю - частку людей, що тестуються щодня та
аналогічне значення для частки вакцинованих людей. При цьому вважається, що
вакциновані люди вже не хворіють, тобто відразу потравляють до групи R.

В даній роботі було проведено дослідження впливу параметрів моделі на розвинення
моделі, а також розглянуто як контроль впливає на граничні значення моделі.
Файл 
[research.pdf](https://github.com/dPaliura/Control_theory_labs/blob/main/lab2/research.pdf)
містить повний опис моделі та текст зазначеного дослідження.

### Лабораторна робота 3

Остання лабораторна робота розглядає чисельне рішення варіаційнох задачі. Ця
задача полягає у знаходженні наближення деякої гладкої функції набором із N+1
точки, яка оптимізує інтеграл цільової функію на часовому інтервалі із
фіксованими кінцями та фіксованими початковою та кінцевою координатами.
Файл
[report.pdf](https://github.com/dPaliura/Control_theory_labs/blob/main/lab3/report.pdf)
містить більш повне та коректне формулювання варіаційної задачі, а також
постановку задачі лабораторної роботи та виконання поставленої задачі.

Рішення саме такої задачі могло бути застосованим у першій та другій роботах
для знаходження оптимальних значень змінних контролю.

Для виконання поставленого завдання даної роботи було написано один модуль, який
містить функцію, що повертає рішення задачі варіаційного числення у вигляді
об'єкту спеціального класу, а тому було написано дві загальні (generic) функції
для цього класу:

* summary - для текстової інтерпретації даного об'єкту,
* plot - для побудови графіку отриманого розв'язку.

Розроблений програмний застосунок не є інтерактивним, хоча є досить зручним і
зрозумілим у використанні, а також дозволяє налаштовувати параметри самої задачі
та оптимізаційного методу, що використовується для її вирішення.


## RU

═══════════════════════════════████
═════════════════════███████═██═══██████
═══════════════════███═════███═══███═══███
══════════════════██═══════██════█████████
════════════════█████═══════█═════█══════██
════════════█████══██═══════█════██═══════█
═══════════██═══════█═══════██═══██═████══█
═══════█████════════██══════██═══█═█═══██═█
═════███═══██════════█═══════█═══█═██═══███
═══██═══════███══════██══════██████══█████
══██═════════██══════██═██████════███████
═██══█════════██══════█══██═██═══════██
███████════════█═════██═════██═══════██
█════███══██████═████═█═████████══════██
█═════███══════█══════██══███═███═════██
██████████═══███═══█══█████═════███════██
█═══════██══████═████████══════════██══██
█════════█████████══███═════════════█══██
█══════════██████████═════════════════███
██═══════════════███══════════════════██
██══════════════███══════════════════██
██═════════════████═════════════════███
═██════════════█═██═════════════════██
═██═══════════██═█═════════════════██
══██═════════════█════════════════██
══██═════════════█═══════════════███
═══██═══════════════════════════███
════█══════════════════════════███
═════██═══════════█═███══════███
══════█████████████═███████████
══════█████████████═███═█████
══════██════════█═█═█═══█═███
══════██═══════██═█═█═══█═███
══════██═══════██═█═█═══██═██
══════██═══════██═█════█═█═██
══════██══════███═█════██████
══════███████████████████████ 

