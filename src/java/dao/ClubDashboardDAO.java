package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import util.DBConnection;

public class ClubDashboardDAO {

    // 1. Get Club Info (Now includes Position)
    public Map<String, String> getClubInfo(String userId) {
        Map<String, String> clubInfo = new HashMap<>();

        // SQL now explicitly selects cm.Position
        String sql = "SELECT c.clubId, c.clubName, c.logoPath, c.mission, c.vision, cm.Position "
                + "FROM club c "
                + "JOIN club_memberships cm ON c.clubId = cm.clubId "
                + "WHERE cm.userId = ? AND cm.isActive = 1";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    clubInfo.put("clubId", String.valueOf(rs.getInt("clubId")));
                    clubInfo.put("clubName", rs.getString("clubName"));
                    clubInfo.put("logoPath", rs.getString("logoPath"));
                    clubInfo.put("mission", rs.getString("mission"));
                    clubInfo.put("vision", rs.getString("vision"));
                    // CRITICAL FIX: Storing position in the map
                    clubInfo.put("position", rs.getString("Position"));
                } else {
                    return getClubInfoFallback(userId);
                }
            }
        } catch (SQLException e) {
            return getClubInfoFallback(userId);
        }
        return clubInfo;
    }

    private Map<String, String> getClubInfoFallback(String userId) {
        Map<String, String> clubInfo = new HashMap<>();
        String sql = "SELECT c.clubId, c.clubName, c.logoPath, c.mission, c.vision, cm.Position "
                + "FROM Clubs c "
                + "JOIN Club_Memberships cm ON c.clubId = cm.clubId "
                + "WHERE cm.userId = ? AND cm.isActive = 1";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    clubInfo.put("clubId", String.valueOf(rs.getInt("clubId")));
                    clubInfo.put("clubName", rs.getString("clubName"));
                    clubInfo.put("logoPath", rs.getString("logoPath"));
                    clubInfo.put("position", rs.getString("Position"));
                    try {
                        clubInfo.put("mission", rs.getString("mission"));
                    } catch (Exception ex) {
                    }
                    try {
                        clubInfo.put("vision", rs.getString("vision"));
                    } catch (Exception ex) {
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return clubInfo;
    }

    // 2. Count Members
    public int getClubMembersCount(int clubId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM club_memberships WHERE clubId = ? AND isActive = 1";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
}
