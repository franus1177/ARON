using System.Collections;
//using System.Net.Mail;

namespace WebPortal.UI.Web
{
    public class SendMail
    {
        public void SendEmails(string FromEmailId, string ToEmailId, string Subject, string message, ArrayList attachedFiles)
        {
            //var mail = new MailMessage();

            //mail.To = ToEmailId.Trim();
            //mail.From = FromEmailId.ToString();
            //mail.Subject = Subject;
            //mail.Body = message;
            //mail.BodyFormat = MailFormat.Html;
           
            ////if (attachedFiles.Count > 0)
            ////{
            ////    foreach (string file in attachedFiles)
            ////    {
            ////        MailAttachment attach = new MailAttachment(file);
            ////        // Attach the newly created email attachment //
            ////        mail.Attachments.Add(attach);
            ////    }
            ////}

            //string sSmtpServer = "sendmail.youbroadband.in";
            //string sServerUserName = "pradip@newindiatech.in";
            //string sServerPassword = "pradip";

            //try
            //{
            //    //MailMessage Msg = new MailMessage();
            //    //// Sender e-mail address.
            //    //Msg.From = FromEmailId;
            //    //// Recipient e-mail address.
            //    //Msg.To = ToEmailId;
            //    //Msg.Subject = Subject;
            //    //Msg.Body = message;
            //    //// your remote SMTP server IP.
            //    //SmtpMail.SmtpServer = "10.20.72.1";
            //    //SmtpMail.Send(Msg);

               
            //    mail.Fields["http://schemas.microsoft.com/cdo/configuration/sendusing"] = 2;
            //    mail.Fields["http://schemas.microsoft.com/cdo/configuration/smtpserver"] = sSmtpServer;
            //    if (sServerUserName != string.Empty && sServerPassword != string.Empty)
            //    {
            //        mail.Fields["http://schemas.microsoft.com/cdo/configuration/sendusername"] = sServerUserName;
            //        mail.Fields["http://schemas.microsoft.com/cdo/configuration/sendpassword"] = sServerPassword;
            //    }
            //    SmtpMail.Send(mail);

            //}
            //catch (Exception ex)
            //{
            //    throw ex;
            //}
        }

        //public void SendEmailsNet(string FromEmailId, string ToEmailId, string Subject, string message, ArrayList attachedFiles, string CC)
        //{
        //    string sSmtpServer = "sendmail.youbroadband.in";
        //    string sServerUserName = "pradip@newindiatech.in";
        //    string sServerPassword = "pradip";

        //    //string sSmtpServer = System.Configuration.ConfigurationManager.AppSettings["MailSmtpLogin"];
        //    //string sServerUserName = System.Configuration.ConfigurationManager.AppSettings["MailServerUserName"];
        //    //string sServerPassword = System.Configuration.ConfigurationManager.AppSettings["MailServerPassword"];

        //    int Port = 2; // Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["MailServerPort"]);
        //    bool IsSSL = false;//Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["MailServerIsSSL"]);

        //    try
        //    {

        //        SmtpClient client = new SmtpClient(sSmtpServer, Port);

        //        client.DeliveryMethod = SmtpDeliveryMethod.Network;
        //        client.UseDefaultCredentials = false;
        //        System.Net.NetworkCredential credentials = new System.Net.NetworkCredential(sServerUserName, sServerPassword);
        //        client.EnableSsl = IsSSL;
        //        client.Credentials = credentials;

        //        FromEmailId = sServerUserName;

        //        MailAddress from = new MailAddress(FromEmailId, "EGRC", System.Text.Encoding.UTF8);
        //        MailAddress to = new MailAddress(ToEmailId);


        //        var mail = new System.Net.Mail.MailMessage(from, to);

        //        mail.Subject = Subject;
        //        mail.Body = message;
        //        mail.IsBodyHtml = true;

        //        if (CC != "")
        //        {
        //            mail.CC.Add(CC);
        //        }

        //        client.Send(mail);
        //    }
        //    catch (Exception ex)
        //    {
        //        return;
        //    }
        //}

        //public void SendEmails(string FromEmailId, string ToEmailId, string Subject, string message, ArrayList attachedFiles)
        //{
        //    try
        //    {
        //        MailMessage mail = new MailMessage();
        //        SmtpClient SmtpServer = new SmtpClient("smtp.gmail.com");

        //        mail.From = new MailAddress("your_email_address@gmail.com");
        //        mail.To.Add("to_address");
        //        mail.Subject = "Test Mail";
        //        mail.Body = "This is for testing SMTP mail from GMAIL";

        //        SmtpServer.Port = 587;
        //        SmtpServer.Credentials = new System.Net.NetworkCredential("username", "password");
        //        SmtpServer.EnableSsl = true;

        //        SmtpServer.Send(mail);
        //    }
        //    catch (Exception ex)
        //    {
        //        return;
        //    }
        //}
    }
}
