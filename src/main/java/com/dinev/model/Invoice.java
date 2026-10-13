package com.dinev.model;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;

@Entity
@Getter
@Setter
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "invoices", comment = "Таблицата съхранява данни за фактури")
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** Инvoice номер от PDF-а (или въведен ръчно) */
    private String invoiceNumber;

    @Column(nullable = false)
    private LocalDate periodFrom;

    @Column(nullable = false)
    private LocalDate periodTo;

    /** Зони от фактурата */
    @Column(precision = 12, scale = 3)
    private BigDecimal dayKwh = BigDecimal.ZERO;    // дневна енергия по фактура
    @Column(precision = 12, scale = 3)
    private BigDecimal nightKwh = BigDecimal.ZERO; // нощна енергия по фактура

    @Column(precision = 10, scale = 5)
    private BigDecimal dayPricePerKwh = BigDecimal.ZERO;
    @Column(precision = 10, scale = 5)
    private BigDecimal nightPricePerKwh = BigDecimal.ZERO;

    /** Фиксирани такси, независимо от енергията (мрежов достъп, акциз и т.н.) */
    @Column(precision = 12, scale = 2)
    private BigDecimal fixedFeesTotal = BigDecimal.ZERO;

    @Column(precision = 12, scale = 2)
    private BigDecimal totalAmount = BigDecimal.ZERO;

    @Enumerated(EnumType.STRING)
    private Source source;

    public enum Source { PDF, MANUAL }

//    @OneToMany(mappedBy = "invoice", cascade = CascadeType.ALL, orphanRemoval = true)
//    private List<StationAllocation> allocations = new ArrayList<>();

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getInvoiceNumber() { return invoiceNumber; }
    public void setInvoiceNumber(String invoiceNumber) { this.invoiceNumber = invoiceNumber; }
    public LocalDate getPeriodFrom() { return periodFrom; }
    public void setPeriodFrom(LocalDate periodFrom) { this.periodFrom = periodFrom; }
    public LocalDate getPeriodTo() { return periodTo; }
    public void setPeriodTo(LocalDate periodTo) { this.periodTo = periodTo; }
    public BigDecimal getDayKwh() { return dayKwh; }
    public void setDayKwh(BigDecimal dayKwh) { this.dayKwh = dayKwh; }
    public BigDecimal getNightKwh() { return nightKwh; }
    public void setNightKwh(BigDecimal nightKwh) { this.nightKwh = nightKwh; }
    public BigDecimal getDayPricePerKwh() { return dayPricePerKwh; }
    public void setDayPricePerKwh(BigDecimal p) { this.dayPricePerKwh = p; }
    public BigDecimal getNightPricePerKwh() { return nightPricePerKwh; }
    public void setNightPricePerKwh(BigDecimal p) { this.nightPricePerKwh = p; }
    public BigDecimal getFixedFeesTotal() { return fixedFeesTotal; }
    public void setFixedFeesTotal(BigDecimal fixedFeesTotal) { this.fixedFeesTotal = fixedFeesTotal; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public Source getSource() { return source; }
    public void setSource(Source source) { this.source = source; }
//    public List<StationAllocation> getAllocations() { return allocations; }
}
