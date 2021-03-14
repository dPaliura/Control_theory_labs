# control_theory_labs

Languages: [EN](#EN) | [UA](#UA) | [RU](#RU)

## EN

This repo created for holding laboratory works for subject "Control Theory",
which were accomplished by **Daniel Paliura** - student of KM-73 group 
(2017-2021 study years) of NTUU "Igor Sikorsky KPI".

Contents:
Laboratory work 1 'Navigation Problem of Speed' - folder [lab1](https://github.com/dPaliura/Control_theory_labs/tree/main/lab1)

### Laboratory work 1

Task of this work is in to find control of boat which moves on plane from point
(0, 0) to some stable target with speed v. There is a vector field of stream on
plane. Vector of stream is parallel to abscissa and perpendicular to ordinate in
each plane point. Speed of stream is dependent of y coordinate and expressed as
s(y) = s0 * f(y), 
where s0 - initial speed of stream (on abscissa axis), f(y) - some function, for
example, f(y) = sin(y). Target point defined in Polar Coordinate system with
next parameters:
l - distance to target from origin,
phi - angle between abscissa axis and vector from origin to target.
v, s0, l, phi, f(y) - problem parameters. It is set to solve problem by aiming
method.

Laboratory work task includes research of problem parameters influence. Research
was made and it was proposed alternative algorithm of the problem solution.
Proposed algorithm was compared to aiming method.
File in directory lab1
[report.pdf](https://github.com/dPaliura/Control_theory_labs/blob/main/lab1/research.pdf)
contains full research of parameters, target reach conditions formulation and
prove, proposed algorithm formulation and implementation with R language.

Program developed with R language (R version 4.0.4) in RStudio Desktop 
environment under Ubuntu 20.4.

To run program you need to run script main.R inside lab1 folder. Other scripts
must be in the same folder with main.R script.

The result of program run is description of input data, description of key model
variables and plot with boat movement to target.

One great issue of this problem solution is used method. It is not always 
achievable target will be reached with used method. For example, in my variant
where parameters are set as:
s0 = sqrt(n), v = sqrt(n), l = n, phi = n*pi/25, f(y) = y; 
n = 15 - student number in group list.
In fact, stream blows boat to the side when it approaches to target by vertical.
Given method does not work when n > 2. But it is obviously solvable, because of
f(y) could be used to move around to be blown to the target side by the stream
direction afterward.

Developed program foreseen two ways of data input:
+ By default - input data according to variant with n = 15
+ By hand - each parameter must be entered by user through console. And it is
  available to use R language: you can use built-in functions as cos(), exp(), 
  sqrt(), log() and other mathematical functions and expressions. It is needed
  to be evaluated as numbers.
Also program is restartable. After model compilation and interpretation the user
is asked to restart program.


## UA

Цей репозиторій створено для збереження лабораторних робіт з предмету
"Теорія Керування" , що виконав **Палюра Данило Валерійович** - студент групи 
КМ-73 (2017-2021 навчальні роки) НТУУ "КПІ ім. Ігоря Сікорського". 

Зміст:
Лабораторна робота 1 'Навігаційна задача швидкодії' - папка [lab1](https://github.com/dPaliura/Control_theory_labs/tree/main/lab1)

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
[report.pdf](https://github.com/dPaliura/Control_theory_labs/blob/main/lab1/research.pdf)
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

