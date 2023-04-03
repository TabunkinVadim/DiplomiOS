# DiplomiOS

Данное приложение является мини соцсетью.  
Выполненное на архитектуре MVC.  
Данное приложение работает с облачной базой данных Firebase.
Все данные о пользователях, их фотографиях, публикациях и коментариях к ним расположены в Firebase.

Приложение встречает стартовым окном:  
<img src="https://user-images.githubusercontent.com/98537353/229586441-cb64734e-b325-4ecc-9c35-10dc6e4fcf55.png" width="300">  
  
Можно выбрать регистрацию нового пользователя или вход в существующий аккаунт.  
При нажатии на кнопку "Зарегистрироваться" открывается окно:  
<img src="https://user-images.githubusercontent.com/98537353/229587282-b62d5c5e-1fc2-4316-b7e1-af659375b26f.png" width="300">  
  
Кнопка "Далее" не активна.  
Здесь можно выбрать код страны, при этом библиотека Firebase предоставляет формат номера для проверки правильности ввода:  
<img src="https://user-images.githubusercontent.com/98537353/229591599-aebcd241-ed83-45f8-a4d3-b683e094f2ff.png"  width="300">  
  
Вводим номер телефона и нажимаем "Далее".  
<img src="https://user-images.githubusercontent.com/98537353/229593179-99431637-540e-4cd5-9412-67f49246748c.png"  width="300">   
  
Открывается окно проверки на спам, предоставляемую Firebase:  
<img src="https://user-images.githubusercontent.com/98537353/229593415-67745742-cee7-4ec3-a452-e75d449572ab.png"  width="300">   
  
После прохождения проверки пользователю приходит СМС с кодом подтверждения, который необходимо ввети в поле:  
<img src="https://user-images.githubusercontent.com/98537353/229593894-79809878-f100-42b6-bb65-2ef34b402279.png"  width="300">   
  
Если введеный пароль соответствует СМС в базе данных Firebase регистрируется новый пользователь, осуществляется вход в аккаунт 
и при повторном открытии приложения будет производится прверка входа в Firebase.  
<img src="https://user-images.githubusercontent.com/98537353/229597983-3fd136a6-3eea-4bd3-ad7c-a8b342231c1e.png"  width="900">   
  
Создается базовый профиль и записывается в базу данных Firebase:   
<img src="https://user-images.githubusercontent.com/98537353/229598601-d624cbdf-771e-42cc-8f25-a89853251f65.png"  width="900">   
  
После идет загрузка профиля из базы данных Firebase на смартфон:  
<img src="https://user-images.githubusercontent.com/98537353/229597146-0597176c-3977-4745-bf04-4dafca932e63.png"  width="300">   

Если по каким либо причинам Firebase решает, что произошел выход из аккаунта без участия пользователя, при повторном запуске приложения 
на экран выводится сообщение о выходе:   
<img src="https://user-images.githubusercontent.com/98537353/229595373-2dd12305-89d4-43ff-a3d4-22aaf9893850.png"  width="300">   
  
Далее входим в уже существующий аккаунт:  
<img src="https://user-images.githubusercontent.com/98537353/229599652-ddf599d1-6755-4ef8-8813-89a4d621d9a3.png"  width="300">   
  
Нас встречает лента новостей формирующаяся из публикаций других пользователей.  
Здесь присутствует имитация историй с загрузкой аватарки каждого пользователя:  

<img src="https://user-images.githubusercontent.com/98537353/229600780-de569152-c6c1-430b-9125-114bf7f46b7f.png"  width="300">   
  
Можно открыть чужой профиль, поставить лайк, либо открыть публикацию и оставить под ней коментарий или так же поставить лайк:  
<img src="https://user-images.githubusercontent.com/98537353/229603297-2f79b957-ca5e-4819-8633-d71660e0c664.png"  width="300"> 
<img src="https://user-images.githubusercontent.com/98537353/229603586-2ea780a4-191d-45fb-a61c-12e7e3bde921.png"  width="300"> 
<img src="https://user-images.githubusercontent.com/98537353/229603655-66616842-fc2d-4e09-a48b-48cf30bf4f90.png"  width="300">   
  
На экранке профиля можно отредактировать данные, просмотреть информациюб создать пубоикацию, добавить фото и открыть фотогалерею:  
<img src="https://user-images.githubusercontent.com/98537353/229604867-563f676c-7e16-4db4-b89b-a4518ec681f1.png"  width="300"> 
<img src="https://user-images.githubusercontent.com/98537353/229604889-3ecd1a86-92c5-487f-97c7-2bda57b2e11b.png"  width="300"> 
<img src="https://user-images.githubusercontent.com/98537353/229605258-1a00d653-b87d-4b1e-b169-d1f0b30d2f22.png"  width="300">   
<img src="https://user-images.githubusercontent.com/98537353/229605311-89c39cd6-7db7-424f-b970-7b92ca0df5d2.png"  width="300"> 
<img src="https://user-images.githubusercontent.com/98537353/229605345-4f795589-2ace-4960-ac97-9eaea0d072e8.png"  width="300"> 
<img src="https://user-images.githubusercontent.com/98537353/229605390-0797ca10-7b64-4589-8b98-686b66250702.png"  width="300">   
  
На чужой странице возможно посмотреть информацию о профиле и зайти в галерею:  
<img src="https://user-images.githubusercontent.com/98537353/229606557-cdae8b49-8991-49b7-9989-a27033a25932.png"  width="300"> 
<img src="https://user-images.githubusercontent.com/98537353/229606577-d1e003fb-96b8-4508-b3f9-41de13e7b016.png"  width="300">  
  
Все отмеченные публикации попадают на вкладку любимое:  
<img src="https://user-images.githubusercontent.com/98537353/229606943-79166cf7-01fb-44d0-b79e-ccf11cbc8a12.png"  width="300">   
Алгоритм добавления и удаления любимых записей реализован через CoreData.  
  
Так же есть экран с Картой на которой реализованы алгоритмы поиска местоположения, установки и удаления булавок, и прокладка маршрута 
от текущего местоположения до сохраненного места:  
<img src="https://user-images.githubusercontent.com/98537353/229608131-6bab5e07-d67b-4389-a9ca-265a08521da8.png"  width="300"> 
<img src="https://user-images.githubusercontent.com/98537353/229608154-a563c77c-6c6d-4988-9b07-a828b6c0ca36.png"  width="300">   
<img src="https://user-images.githubusercontent.com/98537353/229608178-f510dccc-4bfa-493d-80f2-0321c38c6192.png"  width="300">   
  
## Спасибо за внимание!
