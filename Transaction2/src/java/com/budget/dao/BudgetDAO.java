/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Zahier
 */
package com.budget.dao;

import com.budget.model.Budget;
import java.sql.*;
import java.util.*;

public class BudgetDAO {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/expense_tracker";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static List<Budget> getAllBudgets() {
        List<Budget> list = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM budgets")) {
            while (rs.next()) {
                list.add(new Budget(
                    rs.getInt("id"),
                    rs.getString("category"),
                    rs.getDouble("limit_amount"),
                    rs.getDouble("spent")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public static void addBudget(String category, double limit, double spent) {
        String sql = "INSERT INTO budgets (category, limit_amount, spent) VALUES (?, ?, ?)";
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            ps.setDouble(2, limit);
            ps.setDouble(3, spent);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static Budget getBudgetById(int id) {
        String sql = "SELECT * FROM budgets WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Budget(
                    rs.getInt("id"),
                    rs.getString("category"),
                    rs.getDouble("limit_amount"),
                    rs.getDouble("spent")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void updateBudget(int id, String category, double limit, double spent) {
        String sql = "UPDATE budgets SET category=?, limit_amount=?, spent=? WHERE id=?";
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            ps.setDouble(2, limit);
            ps.setDouble(3, spent);
            ps.setInt(4, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void deleteBudget(int id) {
        String sql = "DELETE FROM budgets WHERE id=?";
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}