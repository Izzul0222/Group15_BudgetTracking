<%-- 
    Document   : edit
    Created on : 12 Jun 2025, 9:33:01 am
    Author     : farha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Transaction.Transaction"%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Transactions</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --sidebar-width: 200px;
            --collapsed-width: 50px;
            --header-height: 60px;
            --primary-color: #8a2be2;
            --bg-color: #e6e6fa;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        html, body {
            height: 100%;
            font-family: Arial, sans-serif;
            background-color: var(--bg-color);
        }
        
        .app-container {
            display: flex;
            flex-direction: column;
            height: 100vh;
        }
        
        .header-container {
            display: flex;
            height: var(--header-height);
            background-color: #9370db;
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
        }
        
        .sidebar-toggle {
            width: var(--collapsed-width);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .sidebar-toggle:hover {
            background-color: rgba(255,255,255,0.1);
        }
        
        .header-content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        h2 {
            font-size: 1.5rem;
            background: linear-gradient(90deg, #4b0082, #9370db, #e6e6fa, #9370db, #4b0082);
            background-size: 300% auto;
            color: transparent;
            -webkit-background-clip: text;
            background-clip: text;
            animation: shine 4s linear infinite;
            text-shadow: 0 0 10px rgba(149, 70, 219, 0.3);
        }
            
        @keyframes shine {
            0% { background-position: 0% center; }
            100% { background-position: 100% center; }
        }

        .main-container {
            display: flex;
            flex: 1;
            margin-top: var(--header-height);
        }
        
        .sidebar {
            width: var(--sidebar-width);
            background-color: var(--primary-color);
            color: white;
            height: calc(100vh - var(--header-height));
            position: fixed;
            top: var(--header-height);
            left: 0;
            overflow-x: hidden;
            transition: width 0.3s;
            z-index: 999;
        }
        
        .sidebar.collapsed {
            width: var(--collapsed-width);
        }
        
        .sidebar.collapsed .menu-text {
            display: none;
        }
        
        .sidebar-menu {
            list-style: none;
        }
        
        .sidebar-menu li {
            padding: 15px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            transition: all 0.3s;
            white-space: nowrap;
        }
        
        .sidebar-menu li:hover {
            background-color: rgba(255,255,255,0.1);
        }
        
        .sidebar-menu li.active {
            background-color: rgba(255,255,255,0.2);
        }
        
        .sidebar-menu a {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
        }
        
        .sidebar-menu i {
            margin-right: 15px;
            font-size: 18px;
            min-width: 20px;
            text-align: center;
        }
        
        .content-area {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 20px;
            transition: margin-left 0.3s;
            min-height: calc(100vh - var(--header-height));
        }
        
        .sidebar.collapsed ~ .content-area {
            margin-left: var(--collapsed-width);
        }
        
        /* Form styles */
        table {
            margin-top: 20px;
            width: 100%;
            max-width: 600px;
        }
        
        table td {
            padding: 8px 0;
        }
        
        input[type="text"],
        input[type="number"],
        input[type="date"],
        select {
            padding: 8px;
            width: 100%;
            max-width: 200px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .button-row {
            margin-top: 20px;
        }
        
        .button-row input {
            margin-right: 10px;
            padding: 8px 16px;
            font-size: 14px;
            cursor: pointer;
        }
        
        footer {
            background-color: var(--primary-color);
            color: white;
            text-align: center;
            padding: 10px;
            position: fixed;
            bottom: 0;
            left: var(--sidebar-width);
            right: 0;
            transition: left 0.3s;
            z-index: 900;
        }
        
        .sidebar.collapsed ~ footer {
            left: var(--collapsed-width);
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Header with integrated sidebar toggle -->
        <div class="header-container">
            <div class="sidebar-toggle" onclick="toggleSidebar()">
                <i class="fas fa-bars"></i>
            </div>
            <div class="header-content">
                <h2>Expense Tracker</h2>
            </div>
        </div>
        
        <!-- Main content area -->
        <div class="main-container">
            <!-- Sidebar -->
            <div class="sidebar">
                <ul class="sidebar-menu">
                    <li>
                        <a href="home.jsp">
                            <i class="fas fa-home"></i>
                            <span class="menu-text">Home</span>
                        </a>
                    </li>
                    <li class="active">
                        <a href="viewSuccess.jsp">
                            <i class="fas fa-exchange-alt"></i>
                            <span class="menu-text">Transaction</span>
                        </a>
                    </li>
                    <li>
                        <a href="indexBudget.jsp">
                            <i class="fas fa-wallet"></i>
                            <span class="menu-text">Budget</span>
                        </a>
                    </li>
                </ul>
            </div>
            
            <!-- Content -->
            <div class="content-area">
                <h1>Update Transaction</h1>
                <form action="UpdateServlet" method="post">
                    <table>
                        <tr>
                            <td><input type="hidden" name="id" value="${transaction.id}"/></td>
                        </tr>
                        <tr>
                            <td>Amount:</td>
                            <td><input type="text" name="amount" value="${transaction.amount}"/></td>
                        </tr>
                        <tr>
                            <td>Date:</td>
                            <td><input type="date" name="date" value="${transaction.date}"/></td>
                        </tr>
                        <tr>
                            <td>Category:</td>
                            <td>
                                <select name="category">
                                    <option ${transaction.category == 'Food' ? 'selected' : ''}>Food</option>
                                    <option ${transaction.category == 'Transport' ? 'selected' : ''}>Transport</option>
                                    <option ${transaction.category == 'Rent' ? 'selected' : ''}>Rent</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="button-row">
                                    <input type="submit" value="Save" />
                                    <input type="reset" value="Clear" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </form>
                
            </div>
        </div>
        
        <footer>
            <p>&copy; 2025 Expense Tracker</p>
        </footer>
    </div>

    <script>
        function toggleSidebar() {
            const sidebar = document.querySelector('.sidebar');
            sidebar.classList.toggle('collapsed');
        }
    </script>
</body>
</html>