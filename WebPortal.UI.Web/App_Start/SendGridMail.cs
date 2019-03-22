using System;
using System.Net.Mail;
using System.Net.Mime;

namespace WebPortal.UI.Web
{
    internal class SendGridMail
    {
        public static void Main(string FromEmail, string Tomail, string subject, string Message)
        {
            try
            {
                MailMessage mailMsg = new MailMessage();

                // To
                mailMsg.To.Add(new MailAddress(Tomail, "Test"));

                // From
                mailMsg.From = new MailAddress(FromEmail, "Support Team");

                // Subject and multipart/alternative Body
                mailMsg.Subject = subject;
                string text = Message;
                //string html = @"<p>html body</p>";
                string html = Message;
                //mailMsg.AlternateViews.Add(AlternateView.CreateAlternateViewFromString(text, null, MediaTypeNames.Text.Plain));
                mailMsg.AlternateViews.Add(AlternateView.CreateAlternateViewFromString(html, null, MediaTypeNames.Text.Html));

                // Init SmtpClient and send
                SmtpClient smtpClient = new SmtpClient("smtp.sendgrid.net", Convert.ToInt32(587));
                System.Net.NetworkCredential credentials = new System.Net.NetworkCredential("azure_f75727a2009b9439ae6809268bd11543@azure.com", "GoSymple123");
                smtpClient.Credentials = credentials;

                smtpClient.Send(mailMsg);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            //Execute(FromEmail, Tomail, subject, Message).Wait();
        }

        //static async Task Execute(string FromEmail, string Tomail, string subject, string Message)
        //{
        //    var apiKey = System.Environment.GetEnvironmentVariable("SENDGRID_APIKEY");
        //    var client = new SendGridClient("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");
        //    var msg = new SendGridMessage()
        //    {
        //        From = new EmailAddress(FromEmail, "Support Team"),
        //        Subject = subject,
        //        PlainTextContent = Message,
        //        HtmlContent = "<strong>Hello, Email!</strong>"
        //    };
        //    msg.AddTo(new EmailAddress(Tomail, ""));
        //    var response = await client.SendEmailAsync(msg);
        //}
    }
};