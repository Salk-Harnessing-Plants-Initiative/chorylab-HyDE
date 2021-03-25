import ij.*;
import java.io.*;
import java.lang.Math.*;
import ij.process.*;
import ij.gui.*;
import java.awt.*;
import ij.plugin.*;
import ij.plugin.filter.Analyzer;
import ij.plugin.frame.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.lang.Object;

public class jekell_preprocess implements PlugIn {
	public void run(String arg) {
		final Frame f = new Frame();
		final FileDialog fd = new FileDialog(f, "Open Files...", FileDialog.LOAD);
		fd.setVisible(true);
		String parent_directory = fd.getDirectory();
		IJ.run("Image Sequence...", "open="+parent_directory+"starting=1 increment=1 scale=100 file=_00000.bmp or=[] sort use");
		ImagePlus IP = IJ.getImage();
		ImageStack IS = IP.getStack();
		IJ.run("Set Measurements...", "  bounding display redirect=None decimal=0");
		ij.measure.ResultsTable rt1 = new ij.measure.ResultsTable();
		rt1.show("Results");
		new WaitForUserDialog("Measure for alignment...","Measure rectangular selections for each stack for alignment, then press OK").show();
		rt1 = rt1.getResultsTable();
		int bx_idx = rt1.getColumnIndex("BX");
		int by_idx = rt1.getColumnIndex("BY");
		int w_idx = rt1.getColumnIndex("Width");
		int h_idx = rt1.getColumnIndex("Height");
		float bx_aln[] = rt1.getColumn(bx_idx);
		float by_aln[] = rt1.getColumn(by_idx);
		float w_aln[] = rt1.getColumn(w_idx);
		float h_aln[] = rt1.getColumn(h_idx);
		int n = rt1.getCounter();
		String labels[] = new String[n];
		String all_labels = "";
		for(int i=0; i < n; i++) {
			labels[i] = rt1.getLabel(i);
			all_labels = all_labels + labels[i];
		}
		String include_string = "";
		int num_included = 0;
		for(int i=1; i < IS.getSize() + 1; i++) {
			String s = IS.getShortSliceLabel(i);
			boolean b = all_labels.matches(".*" + s + ".*");
			
			if(b && num_included > 0) {
				include_string = include_string + "," + i;
				num_included = num_included + 1;
			} else if(b) {
				num_included = 1;
				include_string = "" + i;
			}
		}
		IJ.log(include_string);
		IJ.selectWindow("Results");
		IJ.run("Close");
		IJ.run("Select None");
		IJ.run("Make Substack...","slices=" + include_string);
		IJ.selectWindow(IP.getTitle());
		IJ.run("Close");
		ij.measure.ResultsTable rt2 = new ij.measure.ResultsTable();
		rt2.show("Results");
		new WaitForUserDialog("Measure for cropping...","Measure rectangular selections for each stack for cropping the final image, then press OK").show();
		float bx_crp[] = rt2.getColumn(bx_idx);
		float by_crp[] = rt2.getColumn(by_idx);
		float w_crp[] = rt2.getColumn(w_idx);
		float h_crp[] = rt2.getColumn(h_idx);
		n = rt2.getCounter();
		labels = new String[n];
		for(int i=0; i < n; i++) {
			labels[i] = rt2.getLabel(i);
		}

		IJ.run("Close All");
		IJ.selectWindow("Results");
		IJ.run("Close");
		Pattern p = Pattern.compile(".*(_(\\d{2})_).*");	
		for(int i=0; i < n; i++) {
			if(Math.round(bx_aln[i]) == 0 && Math.round(by_aln[i]) == 0) {
				continue;
			}

			int ix = Math.round(w_aln[i]);
			int iy = Math.round(h_aln[i]);
			int x = Math.round(bx_crp[i]) - ix;
			int y = Math.round(by_crp[i]) - iy;
			int w = Math.round(w_crp[i]) + 2*ix;
			int h = Math.round(h_crp[i]) + 2*ix;
			if(x < 0 || x + w > 1392) {
				ix = Math.round(bx_crp[i]);
				x = 0;
				w = 1392;
			}
			if(y < 0 || y+h > 1040) {
				iy = Math.round(by_crp[i]);
				y = 0;
				h = 1040;
			}
			Matcher m = p.matcher(labels[i]);
			m.find();
			
			String child_directory = parent_directory + m.group(2) + "/";
			String grandchild_directory = parent_directory + m.group(2) + "/1/";
			new File(child_directory).mkdir();
			new File(grandchild_directory).mkdir();

			IJ.run("Image Sequence...", "open="+parent_directory+"starting=1 increment=1 scale=100 file="+m.group(1)+" or=[] sort use");
			ImagePlus I = IJ.getImage();
			int numFrames = I.getImageStackSize();
			String parent_filename = I.getTitle();
			IJ.run("8-bit");
			IJ.run("Image Sequence... ", "format=TIFF name=0.tif start=0 digits=4 use save="+child_directory);
			IJ.run("Specify...", "width=" + w + " height=" + h + " x=" + x + " y=" + y + " slice=1");
			IJ.run("Duplicate...", "title=1 duplicate range=1-" + numFrames);
			IJ.selectWindow(parent_filename);
			IJ.run("Specify...","width=" + Math.round(w_aln[i]) + " height=" + Math.round(h_aln[i]) + " x=" + Math.round(bx_aln[i]) + " y=" + Math.round(by_aln[i]) + " slice=1");
			IJ.run("Duplicate...", "title=2 duplicate range=1-" + numFrames);
			IJ.run("closeWindow ", parent_filename);
			IJ.run("MultiStackReg ");
			IJ.selectWindow("1");
			IJ.run("Specify...", "width=" + Math.round(w_crp[i]) + " height=" + Math.round(h_crp[i]) + " x=" + ix + " y=" + iy + " slice=1");
			IJ.run("Crop");
			IJ.run("Image Sequence... ","format=TIFF name=1 start=0 digits=4 use save=" + grandchild_directory + "0.tif");
			IJ.run("Close All");
			IJ.freeMemory();

		}
		
	}

}
