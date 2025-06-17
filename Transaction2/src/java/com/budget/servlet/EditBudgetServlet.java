package com.budget.servlet;

import com.budget.dao.BudgetDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;

@WebServlet("/EditBudgetServlet")
public class EditBudgetServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String category = request.getParameter("category");
            double limit = Double.parseDouble(request.getParameter("limit"));
            double spent = Double.parseDouble(request.getParameter("spent"));
            
            BudgetDAO.updateBudget(id, category, limit, spent);
            response.sendRedirect(request.getContextPath() + "/BudgetServlet");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/editBudget.jsp?error=1&id=" + request.getParameter("id"));
        }
    }
}