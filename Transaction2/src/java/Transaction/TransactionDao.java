package Transaction;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author farha
 */
public class TransactionDao {
    public static Connection getConnection() {
        Connection con = null; 
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/expense_tracker?useSSL=false&serverTimezone=UTC", "root", "");
        } catch (Exception e) {
            System.out.println(e);
        }
        return con;
    }
    
    public static int save(Transaction e) {
        int status = 0;
        try {
            Connection con = TransactionDao.getConnection();
            PreparedStatement ps = con.prepareStatement("insert into transactions(amount,date,category) values (?,?,?)");
            ps.setDouble(1, e.getAmount());
            ps.setString(2, e.getDate());
            ps.setString(3, e.getCategory());
            
            status = ps.executeUpdate();
            
            con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static int update(Transaction e) {
        int status = 0;
        try {
            Connection con = TransactionDao.getConnection();
            PreparedStatement ps = con.prepareStatement("update transactions set amount=?,date=?,category=? where id=?");
            ps.setDouble(1, e.getAmount());
            ps.setString(2, e.getDate());
            ps.setString(3, e.getCategory());
            ps.setInt(4, e.getId());
            
            status = ps.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static int delete(int id) {
        int status = 0;
        try {
            Connection con = TransactionDao.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from transactions where id=?");
            ps.setInt(1, id);
            status = ps.executeUpdate();
            
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
    
    public static Transaction getTransactionById(int id) {
        Transaction e =new Transaction();
        
        try {
            Connection con = TransactionDao.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from transactions where id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                e.setId(rs.getInt(1));
                e.setAmount(rs.getDouble(2));
                e.setDate(rs.getString(3));
                e.setCategory(rs.getString(4));
            }
            con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return e;
    }
    
    public static List<Transaction> getAllTransactions() {
        List<Transaction> list = new ArrayList<Transaction>();
        
        try {
            Connection con = TransactionDao.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from transactions");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Transaction e = new Transaction();
                e.setId(rs.getInt(1));
                e.setAmount(rs.getDouble(2));
                e.setDate(rs.getString(3));
                e.setCategory(rs.getString(4));
                list.add(e);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static Map<String, Double> getSpendingByCategory() {
    Map<String, Double> spendingMap = new HashMap<>();
    try (Connection con = getConnection()) {
        String sql = "SELECT category, SUM(amount) as total FROM transactions GROUP BY category";
        System.out.println("[DEBUG] Executing query: " + sql); // Log the query
        
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                String category = rs.getString("category");
                double total = rs.getDouble("total");
                System.out.println("[DEBUG] Found: " + category + " = " + total); // Log each row
                spendingMap.put(category, total);
            }
        }
    } catch (Exception e) {
        System.err.println("[ERROR] in getSpendingByCategory: ");
        e.printStackTrace();
    }
    return spendingMap;
}
}
