tableextension 50000 "Sales Setup Ext." extends "Sales & Receivables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Total Fare Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50001; "Commission Earned A/c"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50002; "SaaS Commission CGW A/c"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50003; "GST Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50004; "Total Tax on Fare"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50005; "ECO IGST Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50006; "ECO CGST Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50007; "ECO SGST Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50008; "ECO GST Aggregator A/c"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50009; "Edge Discount Offer A/c"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50010; "TDS Payable ECO A/c"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50011; "Net PG/Agent Amt. Collected"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50012; "Abhicash Non Promo"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50013; "Instant Discount"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50014; "Abhicash Promo"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50015; "Edge Discount by Operator"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50016; "Insurance Benfit (Prime User)"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50017; "Service Charge"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50018; "Free Cancellation Fee"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50019; "Prime Membership Fee"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50020; "Assured Subscription Fee"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50021; "Round Off Income"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(70000; "Customer Dimension"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(70001; "E-Invoice User ID"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70002; "E-Invoice Password"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70003; "E-Invoicing Client ID"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70004; "E-Invoicing Client Secret"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70005; "E-Invoice Token"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(70006; "E-Invoice Token Validity"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(70007; "E-Invoice Access Token API"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(70008; "E-Invoice Generation API"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(70009; "E-Invoice Cancellation API"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(70010; "E-Way Generation API"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(70011; "E-Way Cancellation API"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(70012; "Show Json"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
}