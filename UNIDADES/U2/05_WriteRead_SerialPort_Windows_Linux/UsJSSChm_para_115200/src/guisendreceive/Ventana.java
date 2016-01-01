package guisendreceive;

import java.awt.*;
import java.awt.event.*;//1/5

import javax.swing.JOptionPane;

import jssc.SerialPortList;//used in actionPerformed for MImostrarPort

import jssc.SerialPort;
import jssc.SerialPortEvent;
import jssc.SerialPortEventListener;
import jssc.SerialPortException;

public class Ventana implements ActionListener, SerialPortEventListener {// 2/5
	Frame F;
	MenuBar MB;
	TextArea TA;
	Menu M;
	MenuItem MImostrarPort;
	MenuItem MIabrirPort;
	MenuItem MIenviarCad;

	static SerialPort serialPort; // Variables para el puerto serial
	String NoPort = new String(); // Variable para almacenar el nombre del puerto

	public Ventana() {
		F = new Frame("Puerto Serial");
		MB = new MenuBar();
		F.setMenuBar(MB);
		F.setLayout(new BorderLayout());
		TA = new TextArea();
		F.add(TA, BorderLayout.CENTER);
		F.addWindowListener(new WindowAdapter() {
			public void windowClosing(WindowEvent we) {
			  F.dispose();
			  if(serialPort!=null){
				try {
					serialPort.closePort();
				} catch (SerialPortException ex) {
					System.out.println(ex);
				}
			  }
			  System.exit(0);
			}
		});
		M = new Menu("Puerto Serie");
		MB.add(M);
		MImostrarPort = new MenuItem("Mostrar Puerto(s)");
		M.add(MImostrarPort);
		MIabrirPort=new MenuItem("Abrir Puerto");
		M.addSeparator();
		M.add(MIabrirPort);
		M.addSeparator();
		MIenviarCad=new MenuItem("Enviar Cad");
		M.add(MIenviarCad);

		MImostrarPort.addActionListener(this);// 3/5
		MIabrirPort.addActionListener(this);
		MIenviarCad.addActionListener(this);

		F.setSize(400, 300);
		F.setLocationRelativeTo(null);
		F.setVisible(true);
	}

	public void actionPerformed(ActionEvent ae) {// 4/5
		String[] portNames;
		String s = new String();
		String cad=new String();
		if (ae.getActionCommand().equals("Mostrar Puerto(s)")) {// 5/5
			portNames = SerialPortList.getPortNames();
			for (int i = 0; i < portNames.length; i++) {
				s = s + portNames[i] + "\n";
			}
			TA.setText(s);
		}
		if(ae.getActionCommand().equals("Abrir Puerto")){
			NoPort=JOptionPane.showInputDialog("Puerto que debe abrirse");
			AbrirPuertoSerie(NoPort); //Se debe pasar el nombre del puerto serial elegido
		}
		if(ae.getActionCommand().equals("Enviar Cad")){
			cad=JOptionPane.showInputDialog("Cadena a enviar");
		      try {
		          serialPort.writeString(cad); //Envia el una cadena por el puerto serial
		          TA.append("\nSe envia:"+cad);
		      }        
		      catch (SerialPortException ex) {
		          System.out.println(ex);
		      }   
		}
	}

	@Override
	public void serialEvent(SerialPortEvent event) {
		if (event.isRXCHAR() && (event.getEventValue() > 0)) {
			try {// lee el dato del puerto serial y lo va agregando al TA
				TA.append("\nSe recibe:"+serialPort.readString());
			} catch (SerialPortException ex) {
				System.out.println("Error in receiving string from COM-port: " + ex);
			}
		}
	}

	/***
	 * Metodo para dejar listo el puerto serial para la recepcion y envio de datos
	 ***/
	private void AbrirPuertoSerie(String nPort) {
	  if(nPort!=null){
		serialPort = new SerialPort(nPort); // Crear el objeto
		try {
			serialPort.openPort();// Abre el puerto serial
			// Configuracion del puerto serial 
			// Set params. Also you can set params by this string: serialPort.setParams(9600, 8, 1, 0);
			serialPort.setParams(SerialPort.BAUDRATE_115200,
			SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);
			serialPort.addEventListener(this, SerialPort.MASK_RXCHAR);
			TA.append("\nPuerto "+nPort+" abierto exitosamente!!\n");
		} catch (SerialPortException ex) {
			System.out.println(ex);
		}
	  }else{
		  JOptionPane.showMessageDialog(null, "NO SE ABRIO PUERTO!!");
	  }
	}

	public static void main(String[] args) {
		new Ventana();
	}
}
