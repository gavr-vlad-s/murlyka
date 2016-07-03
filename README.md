# Введение

Для сборки проектов на языках Си и Си++ применяются разные сиситемы сборки, среди таковых наиболее известные - CMake, GNU Make, Scons, Shake и система, используемая при сборке библиотек Boost. Рассмотрим каждую из упомянутых систем сборки.  
Система GNU Make принимает на вход Makefile с описанием сценария сборки проекта. Этот сценарий сборки вручную писать становится не очень удобно, если исходных файлов достаточно много. Достоинством этой системы сборки является то, что она работает и под Linux и под Windows.   
Системы Scons и CMake являются обёртками над утилитой Make и порождают входные файлы для данной утилиты.  
Система Scons написана на языке Python 2.7, и под Windows 7 не устанавливается, даже если Python 2.7 есть; под Linux проблем с установкой нет.
Отсутствие возможности работы под Windows является недостатком данной системы.  
Makefile, порождаемый сиситемой CMake, устроен сложно и в этом файле прописываются абсолютные пути к исходным текстам и к компилятору.
По умолчанию CMake использует стандартный для операционный системы компилятор языка Си++. Для Linux таким компилятором является g++ (компилятор из коллекции GCC), а для Windows - компилятор из Microsoft Visual Studio. Однако компилятор из Visual Studio не полностью поддерживает последние стандарты языка Си++, в отличие от компилятора из коллекции GCC, и поэтому под Windows тоже лучше использовать g++.
Но для того, чтобы под Windows система CMake использовала g++ и нужные ключи этого компилятора, нужно писать длинную цепочку аргументов командной строки для CMake. Что касается Linux'а, то кроме компилятора коллекции GCC могут быть установлены, например, компиляторы из набора Clang. Для того, чтобы CMake под Linux использовала набор компиляторов Clang, нужно проделать манипуляции, аналогичные тем, которые нужны для того, чтобы CMake под Windows использовала GCC.  
Систему сборки библиотеки Boost не рекомендует использовать автор одной из библиотек Boost, поскольку эта система сложна в использовании.  
Система сборки Shake написана на языке Haskell и для своей работы требует установленные сиситемы Haskell Stack, которая под Linux устанавливается и работает, а под Windows - устанавливается, но не работает. Цель системы Shake писать Makefile-ы как программы на языке Haskell, а потом их компилировать с помощью компилятора языка Haskell и запускать полученную программу, которая и будет собирать нужный проект. Для использования в проектах на C++ - это является недостатком.  
Поэтому хотелось бы для просто сборки исполняемого файла что-нибудь попроще. Именно этому и посвящён проект Мурлыка.  

## Описание формата входного файла

Подаваемый на вход файл состоит из произвольной, в том числе и пустой, последовательности следующих команд:

- project(имя\_проекта основной_файл)

- compiler(имя\_компилятора)

- compiler\_flags(флаги\_компилятора)

- linker(имя\_компоновщика)

- linker\_flags(флаги\_компоновщика)

- source\_dir(каталог\_с\_исходниками)

- source\_exts(расширения\_исходников)

- build\_dir(каталог\_для\_объектных\_файлов\_и\_программы)
 
- include_dirs(список\_каталогов\_для\_заголовочных\_файлов)

- makefile\_name(имя\_для\_Makefile)

- libraries(список\_подключаемых_библиотек)

- library\_dirs(список\_каталогов\_для\_поиска\_библиотек)
 
Команда project указывает имя проекта и имя головного файла (т.е. имя файла с функцией main). Имя головного файла является необязательным. В этом случае именем головного файла является имя проекта с преписанным к нему расширением cpp. Если команда не задана, то головной файл называется main.cpp, а имя проекта будет main.  
Команда compiler задаёт имя используемого компилятора. 
По умолчанию (если эта команда не задана) используется компилятор g++.  
Команда compiler\_flags определяет флаги, передаваемые компилятором. Флаги по умолчанию: -O3 -Wall -std=c++14.  
Команда linker определяет имя компановщика. По умолчанию это - имя компилятора.  
Команда linker\_flags определяет флаги компановщика. Флаги по умолчанию: -s.  
Команда source\_dir определяет каталог с исходными текстами (имеется в виду файлы с расширениями cpp, c++, cxx).  По умолчанию это - текущий каталог.  
Команда source\_exts задаёт расширение файлов с исходным текстом (расширение заголовочных файлов сюда включать не нужно).  
Команда build\_dir определяет каталог, в котором будут находиться объектные файлы и исполняемый файл. Если эта команда не задана, то они будут находиться в корневом каталоге проекта.  
Команда include\_dirs определяет где находится заголовочные файлы для внешних библиотек.  
Команда makefile\_name задаёт имя генерируемого Makefile'а. По умолчанию используется имя Makefile.

Команда libraries определяет заключённый в кавычки список имён подключаемых библиотек, разделённых пробельными символами. Формат имени таков: не нужно указывать префикс lib и суффикс .a.

Команда library\_dirs определяет список путей поиска для подключаемых библиотек.
 
 Здесь имя\_проекта, имя\_для\_Makefile, имя\_компилятора, имя\_компоновщика - идентификаторы. Все прочие аргументы вышеуказанных команд являются строковыми литералами. Под идентификатором понимается любая непустая последовательность латинских букв, десятичных цифр, знаков '+' и '-', знака подчёркивания и точки. Под строковым литералом понимается любая (в том числе и пустая) последовательность символов, заключённая в двойные кавычки. При этом если в строковом литерале нужно указать двойную кавычку, то её следует удвоить.   
 Строковый литерал, являющийся значением аргумента команды source\_exts, представляет из себя список расширений файлов с исходным текстом, разделённых пробельными символами, т.е. пробелами и табуляциями. Расширения нужно указывать без ведущей точки.
 
 Аргумент команды include\_dirs содержит в себе список разделённых точками с запятыми путей к каталогам, содержащим заголовочные файлы для внешних библиотек.
 
 Аргумент команды library\_dirs содержит в себе список разделённых точками с запятыми путей к каталогам, содержащим подключаемые внешние библиотеки.
 
## Примеры
 
 Приведём примеры использования программы Мурлыка.
 
### Пример 1.  
 Пусть дан проект simple01, имеющий следующую структуру:  

	simple01  
		func1.cpp  
		func1.h  
		func2.cpp  
		func2.h  
		simple01.cpp  
		build
     
Допустим, что головным файлом является simple01.cpp, а каталогом сборки - каталог build. Если в корневой каталог проекта поместить файл с именем, например, mkdescr.txt (имя может быть и любым другим, с любым другим расширением) с содержимым

>project(simple01)  
>compiler(g++)  
>linker(g++)  
>source_exts("cpp")  
>build_dir("build")  

то при подаче Мурлыке на вход этого файла получим Makefile со следующим содержимым:

	LINKER      = g++  
	LINKERFLAGS = -s  
	CXX         = g++  
	CXXFLAGS    = -O3 -Wall -std=c++14  
	BIN         = simple01  
	vpath %.o build  
	OBJ         = simple01.o func2.o func1.o  
	LINKOBJ     = simple01.o func2.o func1.o  

	.PHONY: all all-before all-after clean clean-custom

	all: all-before $(BIN) all-after

	clean: clean-custom   
		rm -f ./build/*.o  
		rm -f ./build/$(BIN)

	.cpp.o:  
		$(CXX) -c $< -o $@ $(CXXFLAGS) 

	$(BIN):$(OBJ)  
		$(LINKER) -o $(BIN) $(LINKOBJ) $(LINKERFLAGS)  
		mv $(BIN) $(OBJ) ./build

### Пример 2.  
Пусть имеется проект simple02 со следующей структурой:  

	simple02  
		build  
		include  
			func1.h  
			func2.h  
		src  
			func1.cpp  
			func2.cpp  
			simple02.cpp

Иными словами, файлы с расширением h находятся в каталоге include, а файлы с расширением cpp - в каталоге src.   
Допустим, что головным файлом является simple02.cpp, а каталогом сборки - каталог build. Если в корневой каталог проекта поместить файл с именем, например, mkdescr.txt (имя может быть и любым другим, с любым другим расширением) с содержимым

>project(simple02)  
>compiler(g++)  
>linker(g++)  
>source_exts("cpp")  
>source_dir("src")  
>build_dir("build")  

то при подаче Мурлыке на вход этого файла получим Makefile со следующим содержимым:  

	LINKER      = g++  
	LINKERFLAGS = -s  
	CXX         = g++  
	CXXFLAGS    = -O3 -Wall -std=c++14  
	BIN         = simple02  
	vpath %.cpp src  
	vpath %.o build  
	OBJ         = simple02.o func2.o func1.o  
	LINKOBJ     = build/simple02.o build/func2.o build/func1.o  

	.PHONY: all all-before all-after clean clean-custom

	all: all-before $(BIN) all-after

	clean: clean-custom  
		rm -f ./build/*.o  
		rm -f ./build/$(BIN)  

	.cpp.o:  
		$(CXX) -c $< -o $@ $(CXXFLAGS)   
		mv $@ ./build

	$(BIN):$(OBJ)  
		$(LINKER) -o $(BIN) $(LINKOBJ) $(LINKERFLAGS)  
		mv $(BIN) ./build

Данная работа была выполнена Голяковой Евгенией Валерьевной как выпускная квалификационная работа на степень бакалавра математики, под руководством Гаврилова Владимира Сергеевича, кандидата физико-математических наук, доцента кафедры математической физики и оптимального управления Института информационных технологий, математики и механики, Нижегородского государственного университета имени Н.И. Лобачевского.
