<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map.Entry"%>
<%
// If accessed directly without servlet, redirect to servlet
if (request.getAttribute("spendingData") == null) {
    response.sendRedirect(request.getContextPath() + "/HomeServlet");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <title>Spending Overview</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        
        /* Opera-like header with sidebar integrated */
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

        /* Main content area */
        .main-container {
            display: flex;
            flex: 1;
            margin-top: var(--header-height);
        }
        
        /* Sidebar styles */
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
        
        /* Content area */
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
        
        input[type="number"],
        input[type="date"],
        select {
            padding: 8px;
            width: 100%;
            max-width: 200px;
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
        background-color: #9370db;
        color: white;
        text-align: center;
        padding: 10px;
        position: fixed;
        bottom: 0;
        left: var(--sidebar-width);
        right: 0;
        transition: left 0.3s;
        z-index : 900;
    }
    
    .sidebar.collapsed ~ footer {
        left: var(--collapsed-width);
    }
    
    .chart-container {
            width: 80%;
            max-width: 500px;
            margin: 30px auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        
        .summary-cards {
            display: flex;
            justify-content: space-around;
            margin: 20px 0;
        }
        
        .card {
            background: white;
            padding: 15px;
            border-radius: 8px;
            width: 30%;
            text-align: center;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
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
                    <li class="active">
                        <a href="home.jsp">
                            <i class="fas fa-home"></i>
                            <span class="menu-text">Home</span>
                        </a>
                    </li>
                    <li>
                        <a href="viewSuccess.jsp">
                            <i class="fas fa-exchange-alt"></i>
                            <span class="menu-text">Transaction</span>
                        </a>
                    </li>
                    <a href="../src/java/Transaction/SaveServlet.java"></a>
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
            <h1>Spending Overview</h1>
            
            <div class="summary-cards">
                <div class="card">
                    <h3>Total Spent</h3>
                    <p id="totalSpent">Loading...</p>
                </div>
                <div class="card">
                    <h3>Top Category</h3>
                    <p id="topCategory">Loading...</p>
                </div>
            </div>
            
            <div class="chart-container">
                <canvas id="spendingChart"></canvas>
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
    
    <script>
  function toggleSidebar() {
    document.querySelector('.sidebar').classList.toggle('collapsed');
    document.body.classList.toggle('sidebar-collapsed');
  }
</script>
    
     <script>
        // Chart data from JSP
        const spendingData = {
    <%
    Map<String, Double> data = (Map<String, Double>) request.getAttribute("spendingData");
    if (data != null && !data.isEmpty()) {
        boolean first = true;
        for (Map.Entry<String, Double> entry : data.entrySet()) {
            if (!first) { %>, <% }
            %>"<%= entry.getKey() %>": <%= entry.getValue() %><%
            first = false;
        }
    } else { 
        %>"No Data Available": 0<%
    }
    %>
};

console.log("Chart Data:", spendingData); // Check browser's console

        // Calculate totals
        let total = 0;
        let topCategory = "";
        let maxAmount = 0;
        
        for (const [category, amount] of Object.entries(spendingData)) {
            total += amount;
            if (amount > maxAmount) {
                maxAmount = amount;
                topCategory = category;
            }
        }
        
        // Update summary cards
        document.getElementById('totalSpent').textContent = 'RM' + total.toFixed(2);
        document.getElementById('topCategory').textContent = topCategory || 'N/A';
        
        // Create pie chart
        window.onload = function() {
            const ctx = document.getElementById('spendingChart').getContext('2d');
            new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: Object.keys(spendingData),
                    datasets: [{
                        data: Object.values(spendingData),
                        backgroundColor: [
                            '#a785c7', '#136610', '#33C4FF', '#4BC0C0', '#FF6384', '#FFCE56'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'right',
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const value = context.raw;
                                    const percentage = Math.round((value / total) * 100);
                                    return `${context.label}: RM${value.toFixed(2)} (${percentage}%)`;
                                }
                            }
                        }
                    }
                }
            });
        };
</script>
</body>
</html>