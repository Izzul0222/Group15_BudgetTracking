package com.budget.servlet;

import com.budget.dao.BudgetDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;

@WebServlet("/BudgetServlet")
public class BudgetServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("budgets", BudgetDAO.getAllBudgets());
        request.getRequestDispatcher("/indexBudget.jsp").forward(request, response);
    }
}