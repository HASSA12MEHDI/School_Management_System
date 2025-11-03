<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Receipt.aspx.cs" Inherits="School_Managenment_System12._00.Receipt" %>

    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Fee Payment Receipt - ${receiptData.transactionId}</title>
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            body { 
                font-family: 'Arial', sans-serif; 
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                padding: 20px;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .receipt-container {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                overflow: hidden;
                max-width: 400px;
                width: 100%;
                position: relative;
            }
            .receipt-header {
                background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
                color: white;
                padding: 30px 20px;
                text-align: center;
                position: relative;
            }
            .receipt-header::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #ffd166, #ef476f, #06d6a0);
            }
            .receipt-title {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 5px;
                text-transform: uppercase;
                letter-spacing: 2px;
            }
            .receipt-subtitle {
                font-size: 14px;
                opacity: 0.9;
                margin-bottom: 15px;
            }
            .school-name {
                font-size: 18px;
                font-weight: bold;
                margin-bottom: 5px;
            }
            .receipt-body {
                padding: 30px 25px;
            }
            .receipt-number {
                text-align: center;
                margin-bottom: 25px;
                padding: 10px;
                background: #f8f9fa;
                border-radius: 10px;
                border: 2px dashed #dee2e6;
            }
            .receipt-id {
                font-size: 16px;
                font-weight: bold;
                color: #4361ee;
            }
            .detail-section {
                margin-bottom: 25px;
            }
            .detail-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
                padding-bottom: 10px;
                border-bottom: 1px solid #e9ecef;
            }
            .detail-label {
                font-weight: bold;
                color: #495057;
                font-size: 14px;
            }
            .detail-value {
                color: #212529;
                font-weight: 600;
                text-align: right;
                max-width: 60%;
            }
            .amount-section {
                background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
                color: white;
                padding: 25px;
                border-radius: 15px;
                text-align: center;
                margin: 25px 0;
                position: relative;
                overflow: hidden;
            }
            .amount-section::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
                background-size: 10px 10px;
                animation: float 20s infinite linear;
            }
            @keyframes float {
                0% { transform: translate(0, 0) rotate(0deg); }
                100% { transform: translate(-10px, -10px) rotate(360deg); }
            }
            .amount-label {
                font-size: 14px;
                opacity: 0.9;
                margin-bottom: 8px;
            }
            .amount-large {
                font-size: 36px;
                font-weight: bold;
                margin: 10px 0;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            }
            .amount-words {
                font-size: 12px;
                opacity: 0.9;
                margin-top: 5px;
            }
            .payment-status {
                background: #28a745;
                color: white;
                padding: 8px 20px;
                border-radius: 20px;
                font-weight: bold;
                display: inline-block;
                margin-top: 10px;
            }
            .footer-section {
                text-align: center;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 2px dashed #dee2e6;
            }
            .signature-section {
                display: flex;
                justify-content: space-between;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #dee2e6;
            }
            .signature-box {
                text-align: center;
                flex: 1;
            }
            .signature-line {
                border-top: 1px solid #495057;
                margin: 40px 10px 5px 10px;
            }
            .signature-label {
                font-size: 12px;
                color: #6c757d;
                margin-top: 5px;
            }
            .watermark {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%) rotate(-45deg);
                font-size: 80px;
                color: rgba(67, 97, 238, 0.05);
                font-weight: bold;
                pointer-events: none;
                z-index: 1;
                white-space: nowrap;
            }
            .print-controls {
                background: #f8f9fa;
                padding: 15px;
                text-align: center;
                border-top: 1px solid #dee2e6;
            }
            .print-btn {
                background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
                color: white;
                border: none;
                padding: 12px 30px;
                border-radius: 25px;
                font-weight: bold;
                cursor: pointer;
                margin: 0 5px;
                transition: all 0.3s ease;
            }
            .print-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(67, 97, 238, 0.4);
            }
            .close-btn {
                background: #6c757d;
                color: white;
                border: none;
                padding: 12px 30px;
                border-radius: 25px;
                font-weight: bold;
                cursor: pointer;
                margin: 0 5px;
                transition: all 0.3s ease;
            }
            .close-btn:hover {
                background: #5a6268;
                transform: translateY(-2px);
            }
            @media print {
                body { 
                    background: white !important; 
                    padding: 0 !important;
                }
                .receipt-container { 
                    box-shadow: none !important; 
                    margin: 0 !important;
                    max-width: none !important;
                }
                .print-controls { display: none !important; }
                .watermark { opacity: 0.1 !important; }
            }
        </style>
    </head>
    <body>
        <div class="receipt-container">
            <div class="watermark">PAID</div>
            
            <div class="receipt-header">
                <div class="school-name">SCHOOL MANAGEMENT SYSTEM</div>
                <div class="receipt-title">FEE PAYMENT RECEIPT</div>
                <div class="receipt-subtitle">Official Payment Acknowledgement</div>
            </div>
            
            <div class="receipt-body">
                <div class="receipt-number">
                    <div class="detail-label">Receipt Number</div>
                    <div class="receipt-id">${receiptData.transactionId}</div>
                </div>
                
                <div class="detail-section">
                    <div class="detail-row">
                        <span class="detail-label">Student Name:</span>
                        <span class="detail-value">${receiptData.studentName}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Fee Type:</span>
                        <span class="detail-value">${receiptData.feeType}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Payment Date:</span>
                        <span class="detail-value">${receiptData.paymentDate}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Payment Mode:</span>
                        <span class="detail-value">${receiptData.paymentMode}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Received By:</span>
                        <span class="detail-value">${receiptData.receivedBy}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Remarks:</span>
                        <span class="detail-value">${receiptData.remarks}</span>
                    </div>
                </div>
                
                <div class="amount-section">
                    <div class="amount-label">Amount Paid</div>
                    <div class="amount-large">${receiptData.amount}</div>
                    <div class="amount-words">${convertAmountToWords(receiptData.amount)}</div>
                    <div class="payment-status">PAYMENT SUCCESSFUL</div>
                </div>
                
                <div class="footer-section">
                    <div style="margin-bottom: 10px; color: #6c757d; font-size: 12px;">
                        This is a computer generated receipt. No signature required.
                    </div>
                    <div style="color: #495057; font-size: 11px;">
                        Generated on: ${receiptData.generatedDate}
                    </div>
                </div>
                
                <div class="signature-section">
                    <div class="signature-box">
                        <div class="signature-line"></div>
                        <div class="signature-label">Student/Parent Signature</div>
                    </div>
                    <div class="signature-box">
                        <div class="signature-line"></div>
                        <div class="signature-label">School Authority</div>
                    </div>
                </div>
            </div>
            
            <div class="print-controls">
                <button class="print-btn" onclick="window.print()">🖨️ Print Receipt</button>
                <button class="close-btn" onclick="window.close()">❌ Close Window</button>
            </div>
        </div>
        
        <script>
            function convertAmountToWords(amount) {
                // Remove currency symbol and convert to number
                const num = parseFloat(amount.replace(/[^0-9.]/g, ''));
                if (isNaN(num)) return '';

                // Simple number to words conversion for Indian numbering system
                const units = ['', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine'];
                const teens = ['Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'];
                const tens = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

                if (num === 0) return 'Zero Rupees';

                let words = '';
                let rupees = Math.floor(num);
                let paise = Math.round((num - rupees) * 100);

                // Convert rupees
                if (rupees > 0) {
                    if (rupees >= 10000000) {
                        words += convertCrores(rupees) + ' Crore ';
                        rupees %= 10000000;
                    }
                    if (rupees >= 100000) {
                        words += convertLakhs(rupees) + ' Lakh ';
                        rupees %= 100000;
                    }
                    if (rupees >= 1000) {
                        words += convertThousands(rupees) + ' Thousand ';
                        rupees %= 1000;
                    }
                    if (rupees >= 100) {
                        words += convertHundreds(rupees) + ' Hundred ';
                        rupees %= 100;
                    }
                    if (rupees > 0) {
                        if (words !== '') words += 'and ';
                        words += convertTens(rupees);
                    }
                    words += ' Rupees';
                }

                // Convert paise
                if (paise > 0) {
                    if (words !== '') words += ' and ';
                    words += convertTens(paise) + ' Paise';
                }

                return words + ' Only';

                function convertCrores(num) {
                    return convertThousands(Math.floor(num / 10000000));
                }

                function convertLakhs(num) {
                    return convertThousands(Math.floor(num / 100000));
                }

                function convertThousands(num) {
                    return convertHundreds(Math.floor(num / 1000));
                }

                function convertHundreds(num) {
                    return units[Math.floor(num / 100)] + (Math.floor(num / 100) > 0 ? ' Hundred' : '');
                }

                function convertTens(num) {
                    if (num < 10) return units[num];
                    if (num < 20) return teens[num - 10];
                    return tens[Math.floor(num / 10)] + (num % 10 !== 0 ? ' ' + units[num % 10] : '');
                }
            }

            // Auto-print after 1 second
            setTimeout(() => {
                window.print();
            }, 1000);
        </script>
    </body >
    </html >

