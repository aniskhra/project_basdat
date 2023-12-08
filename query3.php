<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Query 3</title>

    <style>
        body {
            background-color: #fff;
            margin: 0;
            padding: 0;
            font-family: system-ui, 'Segoe UI', 'Open Sans', 'Helvetica Neue', sans-serif;
            display: flex;
            flex-direction: column; /* Mengatur tata letak menjadi kolom */
            align-items: center; /* Menyusun elemen secara horizontal di tengah */
            height: 100vh;
        }

        .navbar {
            background-color: #2419a3;
            padding: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%; /* Mengisi lebar penuh */
            position: fixed; /* Menjadikan navbar tetap di posisi atas */
            top: 0; /* Menempatkan navbar di bagian atas */
            z-index: 1000;
        }

        .web-name {
            margin-top: 0;
            margin-left: 20px;
            color: #fff;
            font-weight: bold;
            font-size: 18px;
        }

        .button-group {
            display: flex;
            align-items: center;
            margin-right: 38px;
        }

        .button-group .button {
            background-color: #2419a3;
            border: none;
            color: #fff;
            margin-left: 10px;
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

        .content-text {
            margin: 120px auto 20px auto; /* Menyesuaikan margin */
            max-width: 60%; /* Sesuaikan lebar teks sesuai kebutuhan */
            text-align: center; /* Menyusun teks di tengah */
        }
        
        table {
            border-collapse: collapse;
            width: 500px;
            border-radius: 10px;
            overflow: hidden;
            background-color: #ffffff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            border: 1px solid whitesmoke;
            padding: 10px;
            text-align: left;
            width: 50%;
        }

        th {
            background-color: #5d68f1;
            color: #ffffff;
        }
        
    </style>
</head>
<body>

    <?php
    $koneksi = mysqli_connect('localhost', 'root', '', 'rentcar') or die('koneksi gagal');
    $counter = 0;
    ?>

    <!-- Menambahkan navigation bar -->
    <div class="navbar">
        <a class="web-name">RENT CAR</a>
        <!-- Menambahkan tombol -->
        <div class="button-group">
            <a href="homepage.php" class="button">Home</a>
            <a href="query1.php" class="button">Query 1</a>
            <a href="query3.php" class="button">Query 3</a>
            <a href="query6.php" class="button">Query 6</a>
            <a href="query9.php" class="button">Query 9</a>
        </div>
    </div>
    <div class="content-text">
        <h3>Query 3</h3>
        <p>Menampilkan harga sewa dan rental_id untuk setiap sewa yang telah selesai.</p>
    </div>
    <div>
        <table>
            <tr>
                <th>Rental ID</th>
                <th>Harga Sewa</th>
            </tr>
            <tbody>

            <?php
            // Include the stored procedure call
            $sql = "CALL CalculateTotalCharge()";
            $result = mysqli_query($koneksi, $sql);

            if (!$result) {
                die("Error: " . mysqli_error($koneksi));
            }

            while ($row = mysqli_fetch_assoc($result)) {
                $bg = $counter % 2 == 0 ? "style='background: #e0ebf2'" : "style='background: #cfd8dc'";
                $counter++;
                ?>
                <tr <?php echo $bg?>>
                    <td><?php echo $row["rental_id"] ?></td>
                    <td><?php echo $row["total_charge"] ?></td>
                </tr>
                <?php
            }
            ?>

            </tbody>
        </table>
    </div>
</body>
</html>
