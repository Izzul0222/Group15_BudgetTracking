    package com.budget.servlet;

import com.budget.dao.BudgetDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;

@WebServlet("/AddBudgetServlet")
public class AddBudgetServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String category = request.getParameter("category");
            double limit = Double.parseDouble(request.getParameter("limit"));
            double spent = Double.parseDouble(request.getParameter("spent"));

            BudgetDAO.addBudget(category, limit, spent);
            response.sendRedirect(request.getContextPath() + "/BudgetServlet");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/addBudget.jsp?error=invalid_number");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/addBudget.jsp?error=server_error");
        }
    }
}