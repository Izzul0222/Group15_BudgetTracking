package com.budget.servlet;

import com.budget.dao.BudgetDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;

@WebServlet("/DeleteBudgetServlet")
public class DeleteBudgetServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            BudgetDAO.deleteBudget(id);
            response.sendRedirect(request.getContextPath() + "/BudgetServlet");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/BudgetServlet?error=delete_failed");
        }
    }
}