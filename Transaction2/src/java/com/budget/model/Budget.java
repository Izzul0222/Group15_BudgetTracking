/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Zahier
 */
package com.budget.model;

public class Budget {
    private int id;
    private String category;
    private double limit;
    private double spent;

    public Budget(int id, String category, double limit, double spent) {
        this.id = id;
        this.category = category;
        this.limit = limit;
        this.spent = spent;
    }

    public int getId() { return id; }
    public String getCategory() { return category; }
    public double getLimit() { return limit; }
    public double getSpent() { return spent; }
    public double getRemaining() { return limit - spent; }

    public void setCategory(String category) { this.category = category; }
    public void setLimit(double limit) { this.limit = limit; }
    public void setSpent(double spent) { this.spent = spent; }
}