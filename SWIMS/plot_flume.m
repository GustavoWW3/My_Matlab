figure('inverthardcopy','off','color','white')
subplot(4,1,1)
plot(tstep(1:6000),eta_full(1:6000,2),'k')
hold on
%plot(t(1:5400),low_data(1:5400,2,14),'r')
xlabel('Time (sec)')
ylabel('Water Elevation (m)')
axis([0 300 -0.2 0.2])
grid

subplot(4,1,2) 
plot(tstep(6001:12000),eta_full(6001:12000,2),'k')
hold on
%plot(t(5401:11400),low_data(5401:11400,2,14),'r')
xlabel('Time (sec)')
ylabel('Water Elevation (m)')
axis([300 600 -0.2 0.2])
grid

subplot(4,1,3) 
plot(tstep(12001:18000),eta_full(12001:18000,2),'k')
hold on
%plot(t(11401:17400),low_data(11401:17400,2,14),'r')
xlabel('Time (sec)')
ylabel('Water Elevation (m)')
axis([600 900 -0.2 0.2])
grid

subplot(4,1,4)
plot(tstep(18001:24000),eta_full(18001:24000,2),'k')
hold on
%plot(t(17401:23400),low_data(17401:23400,2,14),'r')
xlabel('Time (sec)')
ylabel('Water Elevation (m)')
axis([900 1200 -0.2 0.2])
grid

figure('inverthardcopy','off','color','white')
subplot(4,1,1)
plot(t(1:5400),high_data(1:5400,2,14),'k')
hold on
plot(t(1:5400),low_data(1:5400,2,14),'r')
xlabel('Time (sec)')
ylabel('Water Elevation (m)')
axis([0 300 -0.2 0.2])
grid

subplot(4,1,2) 
plot(t(5401:11400),high_data(5401:11400,2,14),'k')
hold on
plot(t(5401:11400),low_data(5401:11400,2,14),'r')
xlabel('Time (sec)')
ylabel('Water Elevation (m)')
axis([300 600 -0.2 0.2])
grid

subplot(4,1,3) 
plot(t(11401:17400),high_data(11401:17400,2,14),'k')
hold on
plot(t(11401:17400),low_data(11401:17400,2,14),'r')
xlabel('Time (sec)')
ylabel('Water Elevation (m)')
axis([600 900 -0.2 0.2])
grid

subplot(4,1,4)
plot(t(17401:23400),high_data(17401:23400,2,14),'k')
hold on
plot(t(17401:23400),low_data(17401:23400,2,14),'r')
xlabel('Time (sec)')
ylabel('Water Elevation (m)')
axis([900 1200 -0.2 0.2])
grid


figure('inverthardcopy','off','color','white')
subplot(3,1,1)
semilogy(f_a(:,2,14),px_a(:,2,14),'k')
xlabel('Frequency (Hz)')
ylabel('S(f) (m^2/Hz)')
axis([0 1.5 10^-5 10^0])

subplot(3,1,2)
semilogy(f_a(:,2,14),px_l(:,2,14),'k')
xlabel('Frequency (Hz)')
ylabel('S(f) (m^2/Hz)')
axis([0 1.5 10^-5 10^0])

subplot(3,1,3)
semilogy(f_a(:,2,14),px_high(:,2,14),'k')
xlabel('Frequency (Hz)')
ylabel('S(f) (m^2/Hz)')
axis([0 1.5 10^-5 10^0])

