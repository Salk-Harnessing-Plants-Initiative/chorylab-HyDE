Hello Russell,

Enable the . NET Framework 3.5 in Control Panel
Press the Windows key. on your keyboard, type "Windows Features", and press Enter. The Turn Windows features on or off dialog box appears.
Select the . NET Framework 3.5 (includes . NET 2.0 and 3.0) check box, select OK, and reboot your computer if prompted.

Regards,
Bill

Your comment:
Couldn’t install SmartView on windows 10. Needed some dll. Tried fire
package but that needed .Net3.5 which windows failed to find online

On Fri, Mar 26, 2021 at 2:09 PM "support@alliedvision.com" <
support@alliedvision.com> <support@alliedvision.com> wrote:

> Hello Russell,
>
> It's not just thunderbolt3 port on Windows. It 's a thunderbolt to 1394
> driver that is also necessary.
>
> I don't know of one.
>
> Regards,
> Bill
>
> Your comment:
> Thanks Bill. I know some windows computers have Thunderbolt 3 ports (so not
> just USB C). You think we have decent odds with that?
>
>
>
> On Fri, Mar 26, 2021 at 10:27 AM "support@alliedvision.com" <
> support@alliedvision.com> <support@alliedvision.com> wrote:
>
> > Hello Russell,
> >
> > Finding a firewire card is getting more difficult all the time.
> > There are some still available. I see Startech has at least one.
> >
> > I don't know of newer laptops having any way to sue firewire.
> > But, desktops, 1394 PCIe cards.
> >
> > Regards,
> > Bill
> >
> > Bill Porcaro // Sr Applications Engineer – Americas Team Lead
> >
> > Your comment:
> > Ah, so generally for Windows 10 you guys use a port card to be able to
> > accept 6pin Firewire for Marlin? Or how have you done it / would do it?
> > Other than the 3 daisy chain I linked to
> >
> > Thank you,
> > Russell Tran
> >
> > On Fri, Mar 26, 2021 at 8:48 AM "support@alliedvision.com" <
> > support@alliedvision.com> <support@alliedvision.com> wrote:
> >
> > > Hello Russell,
> > >
> > > Firepackage and Smartview work on Windows 10.
> > >
> > > Marlin should have a label on the camera body that specifies the model.
> > >
> > >
> > >
> >
> https://cdn.alliedvision.com/fileadmin/content/software/software/FirePackage/AVTFirePackage3_1_1.zip
> > >
> > >
> > >
> >
> https://www.alliedvision.com/en/support/technical-documentation/marlin-documentation.html
> > >
> > > Regards,
> > > Bill
> > >
> > > Your comment:
> > > Thanks, we have a Marlin camera from 10 years ago. Is there a way for
> us
> > to
> > > tell which version it is and which version SmartView should be
> compatible
> > > with it?
> > >
> > > Generally speaking, has SmartView worked on Windows 10? (Suppose we
> put a
> > > firewire port into our desktop)
> > >
> > > On Fri, Mar 26, 2021 at 5:29 AM "support@alliedvision.com" <
> > > support@alliedvision.com> <support@alliedvision.com> wrote:
> > >
> > > > Hello Russell,
> > > >
> > > > Sorry no. USB3.1 and 1394 are not compatible. You need a 1394 device.
> > > > The link you show is a Thunderbolt connection on an Apple computer
> that
> > > > has the USB-C connector. Not quite the same.
> > > >
> > > > That might work, we have not tested Apple's thunderbolt to 1394
> driver.
> > > > You would need something like libdc1394 working on top. Again, an
> > > unknown.
> > > >
> > > > https://sourceforge.net/p/libdc1394/mailman/message/36220728/
> > > >
> > > > Regards,
> > > > Bill
> > > >
> > > > Bill Porcaro // Sr Applications Engineer – Americas Team
> > <
> > > >
> > > > Your comment:
> > > > Can you connect 6 pin FireWire to Windows 10 USB-C? Will this work:
> > > >
> > >
> >
> https://www.pro-tools-expert.com/production-expert-1/2019/2/12/is-it-possible-to-get-firewire-400-devices-to-work-with-thunderbolt-3-usb-c-and-breathe-life-back-into-our-old-audio-interfaces
> > > >