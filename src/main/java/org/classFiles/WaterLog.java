package org.classFiles;

    import jakarta.persistence.*;
    import java.time.LocalDateTime;

    @Entity
    @Table(name = "water_logs")
    public class WaterLog {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "id")
        private Long logId;

        @ManyToOne
        @JoinColumn(name = "user_id")
        private User user;

        @Column(name = "amount")
        private int amount;

        @Column(name = "amountMl")
        private int amountMl;

        @Column(name = "timestamp")
        private LocalDateTime timestamp;

        // Constructors
        public WaterLog() {}

        public WaterLog(User user, int amountMl) {
            this.user = user;
            this.amount = amountMl;     // Set both fields with the same value
            this.amountMl = amountMl;
            this.timestamp = LocalDateTime.now();
        }

        // Getters and setters
        public Long getLogId() {
            return logId;
        }

        public void setLogId(Long logId) {
            this.logId = logId;
        }

        public User getUser() {
            return user;
        }

        public void setUser(User user) {
            this.user = user;
        }

        public int getAmount() {
            return amount;
        }

        public void setAmount(int amount) {
            this.amount = amount;
        }

        public int getAmountMl() {
            return amountMl;
        }

        public void setAmountMl(int amountMl) {
            this.amountMl = amountMl;
        }

        public LocalDateTime getTimestamp() {
            return timestamp;
        }

        public void setTimestamp(LocalDateTime timestamp) {
            this.timestamp = timestamp;
        }
    }