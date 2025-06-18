using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Net.Sockets;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SimpleLogForwarder
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            cmbProtocol.Items.Add("UDP");
            cmbProtocol.Items.Add("TCP");
            cmbProtocol.SelectedIndex = 0;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string ip = txtIP.Text.Trim();
            string portText = txtPort.Text.Trim();
            string protocol = cmbProtocol.SelectedItem.ToString();
            string message = txtMessage.Text.Trim();

            if (!IPAddress.TryParse(ip, out IPAddress ipAddress))
            {
                MessageBox.Show("Invalid IP address.");
                return;
            }

            if (!int.TryParse(portText, out int port) || port < 1 || port > 65535)
            {
                MessageBox.Show("Invalid port number.");
                return;
            }

            if (string.IsNullOrEmpty(message))
            {
                MessageBox.Show("Message cannot be empty.");
                return;
            }

            try
            {
                byte[] data = Encoding.UTF8.GetBytes(message);

                if (protocol == "UDP")
                {
                    using (UdpClient udpClient = new UdpClient())
                    {
                        udpClient.Send(data, data.Length, ip, port);
                    }
                }
                else if (protocol == "TCP")
                {
                    using (TcpClient tcpClient = new TcpClient())
                    {
                        tcpClient.Connect(ip, port);
                        using (NetworkStream stream = tcpClient.GetStream())
                        {
                            stream.Write(data, 0, data.Length);
                        }
                    }
                }

                MessageBox.Show("Message sent successfully!");
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Failed to send message: {ex.Message}");
            }
        }
    }

}
