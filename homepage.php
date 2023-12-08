<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home Page</title>
    <!-- Styling menggunakan CSS -->
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: system-ui, 'Segoe UI', 'Open Sans', 'Helvetica Neue', sans-serif;
        }

        .navbar {
            background-color: #2419a3;
            padding: 8px; 
            display: flex;
            justify-content: space-between; /* Mengatur elemen di tengah */
            align-items: center; /* Menyusun elemen secara vertikal di tengah */
        }
        
        .web-name {
           margin-top: 0;
           margin-left: 12px;
           color: #fff;
           font-weight: bold;
           font-size: 18px;
        }

        /* Mengelompokkan tombol-tombol dalam div */
        .button-group {
            display: flex;
            align-items: center;
        }

        /* Mengatur jarak antar tombol dan penempatan di sebelah kanan */
        .button-group .button {
            background-color: #2419a3;
            border: none;
            color: #fff;
            margin-left: 10px; /* Sesuaikan jarak antar tombol */
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            padding: 8px 16px;
            text-align: center;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .button-group .button:hover {
            color: #5d68f1;
        }

        /* Menambahkan margin pada tombol-tombol di sebelah kanan */
        .button-group {
            margin-left: auto;
            margin-right: 30px;
        }

        .content {
            margin: 120px auto;
            max-width: 800px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            text-align: left;
        }

        .content-text {
            max-width: 50%; /* Sesuaikan lebar teks sesuai kebutuhan */
        }

        .content p {
            font-size: 18px;
        }

        .content img {
            width: 320px; /* Sesuaikan lebar gambar sesuai kebutuhan */
            height: auto;
        }

        
    </style>
</head>
<body>
    <!-- Menambahkan navigation bar -->
    <div class="navbar">
        <a class="web-name">RENT CAR</a>
        <!-- Menambahkan tombol -->
        <div class="button-group">
            <a href="query1.php" class="button">Query 1</a>
            <a href="query3.php" class="button">Query 3</a>
            <a href="query6.php" class="button">Query 6</a>
            <a href="query9.php" class="button">Query 9</a>
        </div>
    </div>
    <!-- Menambahkan class content -->
    <div class="content">
        <!-- Menambahkan judul dan paragraf -->
        <div class="content-text">
            <h1>Project Akhir Basis Data: Studi Kasus 4 "Rent Car"</h1>
            <p>Annisa Alimatul Khoiria (22537141004)</p>
        </div>
        <!-- Menambahkan gambar -->
        <img src="gambar.jpg" alt="Gambar" />
    </div>
</body>
</html>
