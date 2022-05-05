﻿
&НаКлиенте
Процедура СхемыЛеченийВыборПриИзменении(Элемент)  
	
	ТекНомерСтр = Элементы.СхемыЛечений.ТекущиеДанные.НомерСтроки;
	Для каждого Строка из Объект.СхемыЛечений Цикл
		Если Строка.НомерСтроки <> ТекНомерСтр Тогда
			Строка.Выбор = ЛОЖЬ;
		КонецЕсли;
	КонецЦикла;	

КонецПроцедуры

&НаКлиенте
Процедура НайтиСхемыЛечения(Команда)
	
	РезультатПроверки = ПроверкаЗаполнения();
	Если РезультатПроверки.Положительный Тогда
		Объект.СхемыЛечений.Очистить();	
		НайтиСхемыЛеченияНаСервере();
	Иначе
		ВывестиОшибки(РезультатПроверки.МассивНезаполненныхПолей);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура НайтиСхемыЛеченияНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РезультатЛечения.СхемаЛечения КАК Схема,
	               |	ВЫБОР
	               |		КОГДА РезультатЛечения.Эффективное
	               |			ТОГДА 1
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК КатегорияЭффективности
	               |ИЗ
	               |	РегистрСведений.РезультатЛечения КАК РезультатЛечения
	               |ГДЕ
	               |	РезультатЛечения.Диагноз = &Диагноз";
	Запрос.УстановитьПараметр("Диагноз", Объект.Диагноз);
	Выборка = Запрос.Выполнить().Выбрать(); 
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.СхемыЛечений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
КонецПроцедуры	

&НаСервере
Функция ПроверкаЗаполнения()
	
	МассивНезаполненныхПолей = Новый Массив;
	СтруктураЗаполнения = ИнициализацияЗаполнения();
	Для каждого Элемент из СтруктураЗаполнения Цикл
		Если НЕ Элемент.Значение Тогда
			 МассивНезаполненныхПолей.Добавить(Элемент.Ключ);
		КонецЕсли;	
	КонецЦикла;	
	
	СтруктураЗаполнения.Вставить("Положительный", МассивНезаполненныхПолей.Количество() = 0); 
	Если  НЕ СтруктураЗаполнения.Положительный Тогда
		 СтруктураЗаполнения.Вставить("МассивНезаполненныхПолей", МассивНезаполненныхПолей);
	КонецЕсли;
	
	Возврат  СтруктураЗаполнения;
	
КонецФункции

&НаСервере
Функция ИнициализацияЗаполнения() 
	
	Структура = Новый Структура;
	Структура.Вставить("Возраст", Объект.Возраст > 0);
	Структура.Вставить("Диагноз", ЗначениеЗаполнено(Объект.Диагноз));
	Структура.Вставить("Противопоказания", СписокИспользуемыхПротивопоказаний.Количество() > 0);
	Структура.Вставить("Симптомы", СписокИспользуемыхСимптомов.Количество() > 0); 
	
	Возврат Структура; 
	
КонецФункции

&НаСервере
Процедура ВывестиОшибки(МассивНезаполненныхПолей)
	
	ВсеОшибки = "";
	Для каждого Элемент из МассивНезаполненныхПолей Цикл
		ВсеОшибки = ВсеОшибки + Элемент + "; "
	КонецЦикла;	  
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = "Не заполнены поля " + ВсеОшибки;
	Сообщение.Сообщить();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСхемуЛеченияПациента(Команда)
	
	ОткрытьФорму("Документ.СхемаЛеченияКонкретногоПациента.Форма.ФормаДокумента");
	
КонецПроцедуры

&НаКлиенте
Процедура СхемыЛеченийПриИзменении(Элемент) 
	
	ДоступностьКнопкиСозданияДокумента(); 
	
КонецПроцедуры

&НаСервере
Процедура ДоступностьКнопкиСозданияДокумента()  

	Элементы.СоздатьСхемуЛеченияПациента.Доступность = Объект.СхемыЛечений.Количество() > 0;
	
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка) 
	
	ДоступностьКнопкиСозданияДокумента();  
	
КонецПроцедуры
