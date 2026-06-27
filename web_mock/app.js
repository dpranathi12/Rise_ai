/* ==========================================================================
   RiseAI - Simulation Application Logic
   ========================================================================== */

document.addEventListener("DOMContentLoaded", () => {
  // --- Audio Synthesis Setup (Web Audio API) ---
  let audioCtx = null;
  let alarmInterval = null;

  function initAudio() {
    if (!audioCtx) {
      audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    }
  }

  function playSound(freq, duration, type = "sine") {
    if (!audioCtx) return;
    try {
      const osc = audioCtx.createOscillator();
      const gain = audioCtx.createGain();
      osc.type = type;
      osc.frequency.setValueAtTime(freq, audioCtx.currentTime);
      gain.gain.setValueAtTime(0.1, audioCtx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.0001, audioCtx.currentTime + duration);
      osc.connect(gain);
      gain.connect(audioCtx.destination);
      osc.start();
      osc.stop(audioCtx.currentTime + duration);
    } catch (e) {
      console.warn("Audio playback failed", e);
    }
  }

  function startAlarmSound() {
    initAudio();
    if (alarmInterval) clearInterval(alarmInterval);
    alarmInterval = setInterval(() => {
      // Elegant warning/alarm dual tone chime
      playSound(880, 0.15, "sine");
      setTimeout(() => {
        playSound(660, 0.15, "sine");
      }, 200);
    }, 1000);
  }

  function stopAlarmSound() {
    if (alarmInterval) {
      clearInterval(alarmInterval);
      alarmInterval = null;
    }
  }

  // --- Views Navigation Engine ---
  const views = {
    splash: document.getElementById("view-splash"),
    onboarding: document.getElementById("view-onboarding"),
    login: document.getElementById("view-login"),
    home: document.getElementById("view-home"),
    analytics: document.getElementById("view-analytics"),
    history: document.getElementById("view-history"),
    settings: document.getElementById("view-settings"),
    ringing: document.getElementById("view-ringing"),
    camera: document.getElementById("view-camera"),
    success: document.getElementById("view-success")
  };

  function switchView(targetViewKey) {
    Object.keys(views).forEach(key => {
      if (key === targetViewKey) {
        views[key].classList.add("active");
      } else {
        views[key].classList.remove("active");
      }
    });
  }

  // --- Splash Screen Auto-Redirect ---
  setTimeout(() => {
    switchView("onboarding");
  }, 3500);

  // --- Onboarding Slide Controller ---
  const onboardingSlides = document.querySelectorAll(".onboarding-slide");
  const onboardingDots = document.querySelectorAll(".carousel-dots .dot");
  const onboardingNextBtn = document.getElementById("onboarding-next-btn");
  let currentSlide = 0;

  onboardingNextBtn.addEventListener("click", () => {
    onboardingSlides[currentSlide].classList.remove("active");
    onboardingDots[currentSlide].classList.remove("active");
    
    currentSlide++;
    
    if (currentSlide < onboardingSlides.length) {
      onboardingSlides[currentSlide].classList.add("active");
      onboardingDots[currentSlide].classList.add("active");
      if (currentSlide === onboardingSlides.length - 1) {
        onboardingNextBtn.innerHTML = `Get Started <i class="fa-solid fa-arrow-right"></i>`;
      }
    } else {
      switchView("login");
    }
  });

  // --- Modal Utilities ---
  const modalGoogle = document.getElementById("modal-google-signin");
  const modalEmail = document.getElementById("modal-email-signin");
  const modalProfile = document.getElementById("modal-profile");
  const modalNotifications = document.getElementById("modal-notifications");
  const modalExercises = document.getElementById("modal-exercises");
  const modalAdaptive = document.getElementById("modal-adaptive");

  function showModal(modal) { if (modal) modal.classList.add("active"); }
  function hideModal(modal) { if (modal) modal.classList.remove("active"); }

  // Close buttons listeners
  document.getElementById("close-google-btn").addEventListener("click", () => hideModal(modalGoogle));
  document.getElementById("close-email-btn").addEventListener("click", () => hideModal(modalEmail));
  document.getElementById("close-profile-btn").addEventListener("click", () => hideModal(modalProfile));
  document.getElementById("close-notifications-btn").addEventListener("click", () => hideModal(modalNotifications));
  document.getElementById("close-exercises-btn").addEventListener("click", () => hideModal(modalExercises));
  document.getElementById("close-adaptive-btn").addEventListener("click", () => hideModal(modalAdaptive));

  // --- Login Screen Actions ---
  const userProfileName = document.querySelector(".user-profile h4");
  const userProfileLevel = document.querySelector(".user-profile p");
  const userAvatarIcon = document.querySelector(".avatar i");

  // Load state from localStorage on init
  let userDetails = {
    name: "Guest",
    email: "guest@example.com",
    level: "Level 2 Wake-Up Coach",
    exerciseType: "Squats",
    repetitions: 15,
    difficulty: "Medium"
  };

  try {
    const savedUser = localStorage.getItem("rise_user_details");
    if (savedUser) {
      userDetails = JSON.parse(savedUser);
    }
  } catch (e) {
    console.warn("Could not load user details", e);
  }

  // Enforce modal elements references
  document.getElementById("guest-login-btn").addEventListener("click", () => {
    initAudio();
    userDetails.name = "Guest";
    userDetails.level = "Level 2 Wake-Up Coach";
    saveUserDetails();
    updateProfileUI();
    switchView("home");
  });

  const loginBtns = document.querySelectorAll(".login-btn");
  loginBtns.forEach(btn => {
    if (btn.id !== "guest-login-btn") {
      btn.addEventListener("click", () => {
        initAudio();
        if (btn.classList.contains("google-btn")) {
          showModal(modalGoogle);
        } else if (btn.classList.contains("email-btn")) {
          showModal(modalEmail);
        }
      });
    }
  });

  // Google OAuth account selection click listeners
  const account1 = document.getElementById("google-account-1");
  if (account1) {
    account1.addEventListener("click", () => {
      userDetails.name = "Arpan Deshmukh";
      userDetails.email = "arpan.deshmukh@gmail.com";
      userDetails.level = "Level 5 Wake-Up Coach";
      
      // Sync settings fields
      document.getElementById("profile-name-input").value = userDetails.name;
      document.getElementById("profile-email-input").value = userDetails.email;
      document.getElementById("profile-coach-select").value = userDetails.level;

      saveUserDetails();
      updateProfileUI("google");
      hideModal(modalGoogle);
      switchView("home");
    });
  }

  const account2 = document.getElementById("google-account-2");
  if (account2) {
    account2.addEventListener("click", () => {
      hideModal(modalGoogle);
      // Fallback to manual email login
      showModal(modalEmail);
    });
  }

  // Submit Email Login Modal with fields verification
  document.getElementById("submit-email-login").addEventListener("click", () => {
    const inputName = document.getElementById("email-input-name").value.trim();
    const inputEmail = document.getElementById("email-input-email").value.trim();
    const inputPassword = document.getElementById("email-input-password").value.trim();
    
    if (!inputName || !inputEmail || !inputPassword) {
      alert("Please enter your name, email, and password to sign in!");
      return;
    }
    
    userDetails.name = inputName;
    userDetails.email = inputEmail;
    userDetails.level = "Level 3 Wake-Up Coach";
    
    // Update inputs inside profile settings
    document.getElementById("profile-name-input").value = userDetails.name;
    document.getElementById("profile-email-input").value = userDetails.email;
    document.getElementById("profile-coach-select").value = userDetails.level;

    saveUserDetails();
    updateProfileUI("email");
    hideModal(modalEmail);
    switchView("home");
  });

  function saveUserDetails() {
    try {
      localStorage.setItem("rise_user_details", JSON.stringify(userDetails));
    } catch(e) {}
  }


  function updateProfileUI(type = "guest") {
    if (userProfileName) userProfileName.textContent = "Welcome, " + userDetails.name;
    if (userProfileLevel) userProfileLevel.textContent = userDetails.level;
    if (userAvatarIcon) {
      if (type === "google") {
        userAvatarIcon.className = "fa-brands fa-google";
      } else if (userDetails.name === "User") {
        userAvatarIcon.className = "fa-solid fa-envelope";
      } else {
        userAvatarIcon.className = "fa-solid fa-user";
      }
    }
  }

  // --- Settings Tile Events ---
  document.getElementById("tile-profile").addEventListener("click", () => {
    document.getElementById("profile-name-input").value = userDetails.name;
    document.getElementById("profile-email-input").value = userDetails.email;
    showModal(modalProfile);
  });

  document.getElementById("save-profile-btn").addEventListener("click", () => {
    userDetails.name = document.getElementById("profile-name-input").value || "Guest";
    userDetails.email = document.getElementById("profile-email-input").value || "guest@example.com";
    userDetails.level = document.getElementById("profile-coach-select").value;
    updateProfileUI(userDetails.name === "Arpan Deshmukh" ? "google" : "user");
    hideModal(modalProfile);
  });

  document.getElementById("tile-notifications").addEventListener("click", () => {
    showModal(modalNotifications);
  });

  document.getElementById("save-notifications-btn").addEventListener("click", () => {
    hideModal(modalNotifications);
  });

  document.getElementById("tile-exercises").addEventListener("click", () => {
    document.getElementById("exercise-type-select").value = userDetails.exerciseType;
    document.getElementById("exercise-reps-input").value = userDetails.repetitions;
    document.getElementById("exercise-diff-select").value = userDetails.difficulty;
    showModal(modalExercises);
  });

  document.getElementById("save-exercises-btn").addEventListener("click", () => {
    userDetails.exerciseType = document.getElementById("exercise-type-select").value;
    userDetails.repetitions = parseInt(document.getElementById("exercise-reps-input").value) || 15;
    userDetails.difficulty = document.getElementById("exercise-diff-select").value;

    // Update dynamically on UI
    const alarmDetailsText = document.querySelector(".alarm-time-info p");
    if (alarmDetailsText) {
      alarmDetailsText.textContent = `${userDetails.exerciseType} - ${userDetails.repetitions} reps • Mon-Fri`;
    }
    
    // Update ringing view detail
    document.getElementById("challenge-detail").textContent = `${userDetails.repetitions} ${userDetails.exerciseType}`;
    
    // Update camera target reps
    document.getElementById("camera-exercise-title").textContent = userDetails.exerciseType;
    document.getElementById("camera-target-subtitle").textContent = `Target: ${userDetails.repetitions} reps`;
    document.querySelector(".total-reps").textContent = `/ ${userDetails.repetitions}`;

    hideModal(modalExercises);
  });

  document.getElementById("tile-adaptive").addEventListener("click", () => {
    showModal(modalAdaptive);
  });

  document.getElementById("save-adaptive-btn").addEventListener("click", () => {
    hideModal(modalAdaptive);
  });

  // Theme Toggler
  const tileTheme = document.getElementById("tile-theme");
  const themeBadge = document.getElementById("theme-status-badge");
  const themeText = document.getElementById("theme-tile-text");
  const themeIcon = document.getElementById("theme-tile-icon");
  const screen = document.querySelector(".smartphone-screen");

  tileTheme.addEventListener("click", () => {
    if (screen.classList.contains("light-theme")) {
      screen.classList.remove("light-theme");
      if (themeBadge) themeBadge.textContent = "Dark";
      if (themeText) themeText.textContent = "Theme (Dark Mode)";
      if (themeIcon) {
        themeIcon.className = "fa-solid fa-moon";
      }
    } else {
      screen.classList.add("light-theme");
      if (themeBadge) themeBadge.textContent = "Light";
      if (themeText) themeText.textContent = "Theme (Light Mode)";
      if (themeIcon) {
        themeIcon.className = "fa-solid fa-sun";
      }
    }
  });

  // --- App Inner Navigation Bar ---
  const navItems = document.querySelectorAll(".nav-item");
  navItems.forEach(item => {
    item.addEventListener("click", (e) => {
      const targetViewKey = item.getAttribute("data-target");
      
      // Update active nav indicators in all views
      navItems.forEach(nav => {
        if (nav.getAttribute("data-target") === targetViewKey) {
          nav.classList.add("active");
        } else {
          nav.classList.remove("active");
        }
      });
      
      switchView(targetViewKey);
    });
  });

  // --- Trigger Alarm Simulation ---
  const triggerAlarmBtn = document.getElementById("trigger-alarm-btn");
  triggerAlarmBtn.addEventListener("click", () => {
    initAudio();
    
    // Set current time for alarm ringing screen
    const now = new Date();
    let hours = now.getHours();
    let minutes = now.getMinutes();
    const ampm = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12;
    hours = hours ? hours : 12;
    minutes = minutes < 10 ? '0' + minutes : minutes;
    
    document.getElementById("ringing-time-display").innerHTML = `${hours}:${minutes} <span style="font-size: 24px;">${ampm}</span>`;
    
    switchView("ringing");
    startAlarmSound();
  });

  // --- Reset Simulation ---
  document.getElementById("reset-sim-btn").addEventListener("click", () => {
    stopAlarmSound();
    stopCamera();
    try {
      localStorage.removeItem("rise_user_details");
      localStorage.removeItem("rise_alarms");
    } catch(e) {}
    window.location.reload();
  });

  // --- Ringing Screen: im awake ---
  const imAwakeBtn = document.getElementById("im-awake-btn");
  imAwakeBtn.addEventListener("click", () => {
    stopAlarmSound();
    switchView("camera");
    startCameraSimulation();
  });

  // --- Camera & AI Simulation Controller ---
  const webcam = document.getElementById("webcam");
  const canvas = document.getElementById("skeleton-canvas");
  const ctx = canvas.getContext("2d");
  const cameraStatusPill = document.getElementById("camera-status-pill");
  const currentRepDisplay = document.getElementById("current-rep-count");
  
  let stream = null;
  let animationFrameId = null;
  let repCount = 0;
  let poseDetector = null;
  let isDetectorLoading = false;
  let targetReps = 15;

  async function startCameraSimulation() {
    repCount = 0;
    targetReps = userDetails.repetitions || 15;
    currentRepDisplay.textContent = repCount;
    // Update all "/ 15" spans to the real target
    document.querySelectorAll(".total-reps").forEach(el => el.textContent = targetReps);
    cameraStatusPill.textContent = "⏳ Loading AI Pose Detector...";

    // Keep canvas pixel-perfect as phone mockup resizes
    const resizeObserver = new ResizeObserver(() => {
      if (webcam.readyState >= 2) {
        canvas.width = webcam.clientWidth || 320;
        canvas.height = webcam.clientHeight || 430;
        canvas._videoW = webcam.videoWidth || 320;
        canvas._videoH = webcam.videoHeight || 430;
      }
    });
    resizeObserver.observe(webcam);

    // Dynamic script loader helper
    function loadScript(src) {
      return new Promise((resolve, reject) => {
        const existing = document.querySelector(`script[src="${src}"]`);
        if (existing) { resolve(); return; }
        const s = document.createElement("script");
        s.src = src;
        s.onload = resolve;
        s.onerror = () => reject(new Error("Failed to load: " + src));
        document.head.appendChild(s);
      });
    }

    // Load TF.js packages if missing
    if (typeof tf === "undefined" || typeof poseDetection === "undefined") {
      try {
        cameraStatusPill.textContent = "⏳ Downloading AI Engine (first load)...";
        await loadScript("https://cdn.jsdelivr.net/npm/@tensorflow/tfjs-core@4.2.0/dist/tf-core.min.js");
        await loadScript("https://cdn.jsdelivr.net/npm/@tensorflow/tfjs-backend-webgl@4.2.0/dist/tf-backend-webgl.min.js");
        await loadScript("https://cdn.jsdelivr.net/npm/@tensorflow/tfjs-backend-cpu@4.2.0/dist/tf-backend-cpu.min.js");
        await loadScript("https://cdn.jsdelivr.net/npm/@tensorflow/tfjs-converter@4.2.0/dist/tf-converter.min.js");
        await loadScript("https://cdn.jsdelivr.net/npm/@tensorflow-models/pose-detection@2.1.3/dist/pose-detection.min.js");
        cameraStatusPill.textContent = "✅ AI Engine downloaded!";
      } catch (loadErr) {
        console.error("Could not dynamically load TF.js:", loadErr);
        cameraStatusPill.textContent = "❌ AI Engine failed to download. Check internet connection.";
        return;
      }
    }

    // Initialize MoveNet detector
    if (!poseDetector && !isDetectorLoading) {
      isDetectorLoading = true;
      try {
        cameraStatusPill.textContent = "🧠 Initializing MoveNet AI Model...";
        await tf.ready();
        // Prefer WebGL backend for GPU speed, fall back to CPU
        try {
          await tf.setBackend("webgl");
        } catch (e) {
          await tf.setBackend("cpu");
        }
        const model = poseDetection.SupportedModels.MoveNet;
        poseDetector = await poseDetection.createDetector(model, {
          modelType: poseDetection.movenet.modelType.SINGLEPOSE_LIGHTNING
        });
        console.log("✅ MoveNet loaded. Backend:", tf.getBackend());
      } catch (err) {
        console.error("Failed to initialize MoveNet:", err);
        cameraStatusPill.textContent = "❌ AI Model init failed: " + err.message;
        isDetectorLoading = false;
        return;
      } finally {
        isDetectorLoading = false;
      }
    }

    // Try to open user's webcam
    try {
      stream = await navigator.mediaDevices.getUserMedia({
        video: { width: 320, height: 430, facingMode: "user" }
      });
      webcam.srcObject = stream;
      webcam.onloadedmetadata = () => {
        webcam.play();
        setupCanvas();
        if (poseDetector) {
          startRealAIDetection();
        } else {
          cameraStatusPill.textContent = "AI Model failed to load. Click camera view to skip.";
          startSkeletonTrackingAnimation(false);
          startExerciseCounting();
        }
      };
    } catch (err) {
      console.warn("Could not access webcam, using simulated screen", err);
      setupCanvas();
      startSkeletonTrackingAnimation(true); // run simulated background
      startExerciseCounting();
    }
  }

  function setupCanvas() {
    // Use the rendered size so canvas overlays exactly on the visible video
    canvas.width = webcam.clientWidth || webcam.offsetWidth || 320;
    canvas.height = webcam.clientHeight || webcam.offsetHeight || 430;
    // Store video natural resolution for scaling
    canvas._videoW = webcam.videoWidth || 320;
    canvas._videoH = webcam.videoHeight || 430;
  }

  function stopCamera() {
    if (stream) {
      stream.getTracks().forEach(track => track.stop());
      stream = null;
    }
    if (animationFrameId) {
      cancelAnimationFrame(animationFrameId);
      animationFrameId = null;
    }
  }

  // --- Real AI Detection using TensorFlow.js MoveNet ---
  function startRealAIDetection() {
    cameraStatusPill.textContent = "🧍 Stand back — show full body in frame!";
    playSound(523.25, 0.2);

    let squatState = "up";
    let noBodyFrames = 0;

    // Vector angle at joint B between A-B-C
    function getAngle(a, b, c) {
      const ab = { x: a.x - b.x, y: a.y - b.y };
      const cb = { x: c.x - b.x, y: c.y - b.y };
      const dot = ab.x * cb.x + ab.y * cb.y;
      const magAB = Math.sqrt(ab.x * ab.x + ab.y * ab.y);
      const magCB = Math.sqrt(cb.x * cb.x + cb.y * cb.y);
      if (magAB === 0 || magCB === 0) return 180;
      const cosAngle = Math.min(1, Math.max(-1, dot / (magAB * magCB)));
      return (Math.acos(cosAngle) * 180) / Math.PI;
    }

    async function detectPose() {
      if (!stream || webcam.paused || webcam.ended) return;

      try {
        // Do NOT flip here — canvas already mirrors X coordinates
        const poses = await poseDetector.estimatePoses(webcam);
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        if (poses && poses.length > 0) {
          const kp = poses[0].keypoints;
          drawRealSkeleton(kp);

          const CONF = 0.25; // Low confidence threshold — be permissive

          const lHip   = kp.find(k => k.name === "left_hip");
          const lKnee  = kp.find(k => k.name === "left_knee");
          const lAnkle = kp.find(k => k.name === "left_ankle");
          const rHip   = kp.find(k => k.name === "right_hip");
          const rKnee  = kp.find(k => k.name === "right_knee");
          const rAnkle = kp.find(k => k.name === "right_ankle");

          const leftOk  = lHip?.score > CONF && lKnee?.score > CONF && lAnkle?.score > CONF;
          const rightOk = rHip?.score > CONF && rKnee?.score > CONF && rAnkle?.score > CONF;

          if (!leftOk && !rightOk) {
            noBodyFrames++;
            if (noBodyFrames > 20) {
              cameraStatusPill.textContent = "⚠️ Can't see legs — step back & show full body";
            }
            animationFrameId = requestAnimationFrame(detectPose);
            return;
          }

          noBodyFrames = 0;

          // Use whichever leg has higher combined confidence
          let kneeAngle;
          if (leftOk && rightOk) {
            const la = getAngle(lHip, lKnee, lAnkle);
            const ra = getAngle(rHip, rKnee, rAnkle);
            kneeAngle = (la + ra) / 2; // average both legs
          } else if (leftOk) {
            kneeAngle = getAngle(lHip, lKnee, lAnkle);
          } else {
            kneeAngle = getAngle(rHip, rKnee, rAnkle);
          }

          const angleRounded = Math.round(kneeAngle);

          // SQUAT DOWN: knee angle < 130° (was 110° — too strict)
          if (kneeAngle < 130) {
            if (squatState === "up") {
              squatState = "down";
              cameraStatusPill.textContent = `⬇️ Good squat! Rise up now... (${angleRounded}°)`;
              playSound(330, 0.1);
            } else {
              cameraStatusPill.textContent = `⬇️ Squatting... (${angleRounded}°)`;
            }
          }
          // STANDING UP: knee angle > 155° (was 150°)
          else if (kneeAngle > 155) {
            if (squatState === "down") {
              squatState = "up";
              repCount++;
              currentRepDisplay.textContent = repCount;
              playSound(659, 0.15); // higher confirmation beep
              if (repCount >= targetReps) {
                finishChallenge();
                return;
              } else {
                cameraStatusPill.textContent = `✅ Rep ${repCount}/${targetReps} — Squat again!`;
              }
            } else {
              // Standing — show live angle as feedback
              cameraStatusPill.textContent = `🧍 Standing (${angleRounded}°) — Squat down!`;
            }
          } else {
            // Mid-range — show angle
            cameraStatusPill.textContent = `🔄 Bending... (${angleRounded}°)`;
          }

        } else {
          noBodyFrames++;
          if (noBodyFrames > 15) {
            cameraStatusPill.textContent = "⚠️ No body detected — step back & face the camera";
          }
        }

      } catch (err) {
        console.error("Pose detection error:", err);
      }

      animationFrameId = requestAnimationFrame(detectPose);
    }

    detectPose();
  }

  function drawRealSkeleton(keypoints) {
    const minConfidence = 0.35;

    // Scale from video natural resolution to canvas display size
    const videoW = canvas._videoW || webcam.videoWidth || 320;
    const videoH = canvas._videoH || webcam.videoHeight || 430;
    const scaleX = canvas.width / videoW;
    const scaleY = canvas.height / videoH;

    // White skeleton lines like PushClock
    const adjacentPairs = poseDetection.util.getAdjacentPairs(poseDetection.SupportedModels.MoveNet);
    ctx.strokeStyle = "rgba(255,255,255,0.92)";
    ctx.lineWidth = 3;
    ctx.lineCap = "round";
    ctx.lineJoin = "round";
    ctx.shadowBlur = 0;

    adjacentPairs.forEach(([i, j]) => {
      const kp1 = keypoints[i];
      const kp2 = keypoints[j];
      if (kp1.score > minConfidence && kp2.score > minConfidence) {
        ctx.beginPath();
        // Flip X so it mirrors user like a selfie camera
        ctx.moveTo(canvas.width - (kp1.x * scaleX), kp1.y * scaleY);
        ctx.lineTo(canvas.width - (kp2.x * scaleX), kp2.y * scaleY);
        ctx.stroke();
      }
    });

    // White filled joint dots
    ctx.fillStyle = "rgba(255,255,255,0.95)";
    keypoints.forEach(kp => {
      if (kp.score > minConfidence) {
        ctx.beginPath();
        ctx.arc(canvas.width - (kp.x * scaleX), kp.y * scaleY, 4, 0, Math.PI * 2);
        ctx.fill();
      }
    });
  }

  // Draw simulated tracking skeleton coordinates (Fallback when model loading is skipped/failed)
  function startSkeletonTrackingAnimation(isMockBackground = false) {
    let tick = 0;

    function renderLoop() {
      tick += 0.05;
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      if (isMockBackground) {
        ctx.fillStyle = "#1e1e2f";
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        
        ctx.fillStyle = "rgba(255,255,255,0.05)";
        ctx.beginPath();
        ctx.arc(canvas.width / 2, canvas.height / 2, 80, 0, Math.PI * 2);
        ctx.fill();
      }

      const cx = canvas.width / 2;
      const cy = canvas.height / 2;
      const breathe = Math.sin(tick) * 5;
      const exerciseOffset = Math.abs(Math.sin(tick * 0.5)) * 40;

      const head = { x: cx, y: cy - 70 - breathe + exerciseOffset * 0.7 };
      const neck = { x: cx, y: cy - 40 - breathe + exerciseOffset * 0.7 };
      const lShoulder = { x: cx - 40, y: cy - 30 - breathe + exerciseOffset * 0.7 };
      const rShoulder = { x: cx + 40, y: cy - 30 - breathe + exerciseOffset * 0.7 };
      const lElbow = { x: cx - 60, y: cy + breathe + exerciseOffset * 0.6 };
      const rElbow = { x: cx + 60, y: cy + breathe + exerciseOffset * 0.6 };
      const lWrist = { x: cx - 50, y: cy + 30 + exerciseOffset * 0.5 };
      const rWrist = { x: cx + 50, y: cy + 30 + exerciseOffset * 0.5 };
      
      const hip = { x: cx, y: cy + 20 + exerciseOffset };
      const lHip = { x: cx - 25, y: cy + 20 + exerciseOffset };
      const rHip = { x: cx + 25, y: cy + 20 + exerciseOffset };
      
      const lKnee = { x: cx - 35, y: cy + 70 + exerciseOffset * 0.5 };
      const rKnee = { x: cx + 35, y: cy + 70 + exerciseOffset * 0.5 };
      const lAnkle = { x: cx - 30, y: cy + 130 };
      const rAnkle = { x: cx + 30, y: cy + 130 };

      ctx.strokeStyle = "#00FF66";
      ctx.lineWidth = 4;
      ctx.lineCap = "round";
      ctx.shadowBlur = 10;
      ctx.shadowColor = "#00FF66";

      drawLine(lShoulder, rShoulder);
      drawLine(neck, hip);
      drawLine(lShoulder, lElbow);
      drawLine(lElbow, lWrist);
      drawLine(rShoulder, rElbow);
      drawLine(rElbow, rWrist);
      drawLine(lHip, rHip);
      drawLine(lHip, lKnee);
      drawLine(lKnee, lAnkle);
      drawLine(rHip, rKnee);
      drawLine(rKnee, rAnkle);

      ctx.fillStyle = "#FFFFFF";
      ctx.shadowColor = "#FFFFFF";
      const landmarks = [head, neck, lShoulder, rShoulder, lElbow, rElbow, lWrist, rWrist, lHip, rHip, lKnee, rKnee, lAnkle, rAnkle];
      landmarks.forEach(pt => {
        ctx.beginPath();
        ctx.arc(pt.x, pt.y, 5, 0, Math.PI * 2);
        ctx.fill();
      });

      ctx.shadowBlur = 0;
      animationFrameId = requestAnimationFrame(renderLoop);
    }

    function drawLine(p1, p2) {
      ctx.beginPath();
      ctx.moveTo(p1.x, p1.y);
      ctx.lineTo(p2.x, p2.y);
      ctx.stroke();
    }

    renderLoop();
  }

  function startExerciseCounting() {
    setTimeout(() => {
      if (!poseDetector) {
        cameraStatusPill.innerHTML = "<strong>Error: AI Pose Detector Engine not loaded.</strong> Squat detection unavailable.";
        playSound(440, 0.3); // Error tone
        return;
      }
      cameraStatusPill.innerHTML = "Perform a real squat to silence the alarm!";
      playSound(523.25, 0.2);
    }, 2000);
  }

  function finishChallenge() {
    cameraStatusPill.textContent = "Challenge Completed!";
    playSound(1046.5, 0.4); // Complete chime high C
    
    stopCamera();
    switchView("success");
    
    // Confetti celebration
    confetti({
      particleCount: 150,
      spread: 80,
      origin: { y: 0.6 }
    });
  }

  // --- Success Screen Finish button ---
  document.getElementById("success-done-btn").addEventListener("click", () => {
    // Update streaks to 8 days in Dashboard UI & main view
    document.querySelector(".streak-card .streak-stat h3").textContent = "8 Days";
    
    // Go to home view
    switchView("home");
    
    // Also active nav tab indicator update
    navItems.forEach(nav => {
      if (nav.getAttribute("data-target") === "home") {
        nav.classList.add("active");
      } else {
        nav.classList.remove("active");
      }
    });
  });

  // --- Create Alarm Modal Interactions ---
  const modalCreateAlarm = document.getElementById("modal-create-alarm");
  const addAlarmBtn = document.getElementById("add-alarm-btn");
  const closeCreateAlarmBtn = document.getElementById("close-create-alarm-btn");

  if (addAlarmBtn) {
    addAlarmBtn.addEventListener("click", () => {
      // Default: select ALL 7 days so the alarm fires every day unless user changes it
      dayDots.forEach(dot => dot.classList.add("active"));
      showModal(modalCreateAlarm);
    });
  }

  if (closeCreateAlarmBtn) {
    closeCreateAlarmBtn.addEventListener("click", () => {
      hideModal(modalCreateAlarm);
    });
  }

  // Toggling active days dots
  const dayDots = document.querySelectorAll("#modal-create-alarm .day-dot");
  dayDots.forEach(dot => {
    dot.addEventListener("click", () => {
      dot.classList.toggle("active");
    });
  });

  // AM / PM toggle
  const ampmAmBtn = document.getElementById("ampm-am");
  const ampmPmBtn = document.getElementById("ampm-pm");
  let selectedAmPm = "AM";

  if (ampmAmBtn && ampmPmBtn) {
    ampmAmBtn.addEventListener("click", () => {
      selectedAmPm = "AM";
      ampmAmBtn.classList.add("active");
      ampmPmBtn.classList.remove("active");
    });
    ampmPmBtn.addEventListener("click", () => {
      selectedAmPm = "PM";
      ampmPmBtn.classList.add("active");
      ampmAmBtn.classList.remove("active");
    });
  }

  // Save new alarm functionality
  const saveNewAlarmBtn = document.getElementById("save-new-alarm-btn");
  if (saveNewAlarmBtn) {
    saveNewAlarmBtn.addEventListener("click", () => {
      const hourVal = parseInt(document.getElementById("alarm-hour-select").value);
      const minVal = document.getElementById("alarm-minute-select").value;
      if (!hourVal || !minVal) return;

      // Convert 12h + AM/PM to 24h for internal storage
      let hour24 = hourVal;
      if (selectedAmPm === "AM") {
        if (hourVal === 12) hour24 = 0;   // 12 AM = 00:xx
      } else {
        if (hourVal !== 12) hour24 = hourVal + 12;  // 1 PM = 13, etc.
      }
      const formattedHour24 = hour24 < 10 ? "0" + hour24 : String(hour24);
      const time24 = `${formattedHour24}:${minVal}`;

      // Display stays in 12h with AM/PM
      const displayHour = hourVal < 10 ? "0" + hourVal : String(hourVal);
      const displayTime = `${displayHour}:${minVal}`;

      // Get days
      const days = [];
      const dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
      const activeDots = document.querySelectorAll("#modal-create-alarm .day-dot.active");
      activeDots.forEach(dot => {
        days.push(parseInt(dot.getAttribute("data-day")));
      });

      let daysText = "";
      if (days.length === 7) {
        daysText = "Everyday";
      } else if (days.length === 5 && !days.includes(6) && !days.includes(7)) {
        daysText = "Mon-Fri";
      } else if (days.length === 2 && days.includes(6) && days.includes(7)) {
        daysText = "Sat, Sun";
      } else if (days.length === 0) {
        daysText = "Once";
      } else {
        daysText = days.sort().map(d => dayNames[d - 1]).join(", ");
      }

      const exercise = document.getElementById("alarm-exercise-select").value;
      const reps = parseInt(document.getElementById("alarm-reps-input").value) || 10;

      // Add to UI — store raw 24h time in a data attribute for reliable matching
      const alarmsList = document.querySelector(".alarms-list");
      if (alarmsList) {
        const newAlarm = document.createElement("div");
        newAlarm.className = "alarm-item";
        newAlarm.setAttribute("data-time24", time24);
        newAlarm.setAttribute("data-days", daysText);
        newAlarm.innerHTML = `
          <div class="alarm-time-info">
            <h2>${displayTime} <span>${selectedAmPm}</span></h2>
            <p>${exercise} - ${reps} reps • ${daysText}</p>
          </div>
          <label class="switch">
            <input type="checkbox" checked>
            <span class="slider"></span>
          </label>
        `;
        alarmsList.insertBefore(newAlarm, alarmsList.firstChild);
      }

      // Update state for active trigger
      userDetails.exerciseType = exercise;
      userDetails.repetitions = reps;

      // Update ringing details
      document.getElementById("challenge-detail").textContent = `${reps} ${exercise}`;
      document.getElementById("camera-exercise-title").textContent = exercise;
      document.getElementById("camera-target-subtitle").textContent = `Target: ${reps} reps`;
      document.querySelector(".total-reps").textContent = `/ ${reps}`;

      // Save alarms list to localStorage
      saveAlarmsToLocalStorage();

      // Reset create alarm inputs — select ALL days by default
      document.getElementById("alarm-hour-select").value = "7";
      document.getElementById("alarm-minute-select").value = "00";
      selectedAmPm = "AM";
      if (ampmAmBtn) { ampmAmBtn.classList.add("active"); }
      if (ampmPmBtn) { ampmPmBtn.classList.remove("active"); }
      dayDots.forEach(dot => dot.classList.add("active"));

      hideModal(modalCreateAlarm);
      playSound(783.99, 0.15);
      updateAlarmTodayBadges();
    });
  }

  function saveAlarmsToLocalStorage() {
    try {
      const alarms = [];
      document.querySelectorAll(".alarms-list .alarm-item").forEach(item => {
        const time24 = item.getAttribute("data-time24");
        const days = item.getAttribute("data-days");
        const timeHeader = item.querySelector(".alarm-time-info h2");
        const ampmSpan = timeHeader.querySelector("span");
        const ampm = ampmSpan ? ampmSpan.textContent.trim() : "AM";
        
        // Clean display time text
        const tmp = document.createElement("div");
        tmp.innerHTML = timeHeader.innerHTML;
        const sp = tmp.querySelector("span");
        if (sp) sp.remove();
        const displayTime = tmp.textContent.trim();

        const infoText = item.querySelector(".alarm-time-info p").textContent;
        const parts = infoText.split("•");
        const challengeString = parts[0].trim();
        const repsMatch = challengeString.match(/(\d+)\s+reps/);
        const reps = repsMatch ? parseInt(repsMatch[1]) : 10;
        const exercise = challengeString.split("-")[0].trim();

        const active = item.querySelector("input[type='checkbox']").checked;

        alarms.push({ time24, displayTime, ampm, days, exercise, reps, active });
      });
      localStorage.setItem("rise_alarms", JSON.stringify(alarms));
    } catch (e) {
      console.warn("Could not save alarms", e);
    }
  }

  function loadAlarmsFromLocalStorage() {
    try {
      const savedAlarms = localStorage.getItem("rise_alarms");
      if (savedAlarms) {
        const alarms = JSON.parse(savedAlarms);
        const alarmsList = document.querySelector(".alarms-list");
        if (alarmsList && alarms.length > 0) {
          alarmsList.innerHTML = ""; // clear defaults if user has saved ones
          alarms.forEach(alarm => {
            const newAlarm = document.createElement("div");
            newAlarm.className = "alarm-item";
            newAlarm.setAttribute("data-time24", alarm.time24);
            newAlarm.setAttribute("data-days", alarm.days);
            newAlarm.innerHTML = `
              <div class="alarm-time-info">
                <h2>${alarm.displayTime} <span>${alarm.ampm}</span></h2>
                <p>${alarm.exercise} - ${alarm.reps} reps • ${alarm.days}</p>
              </div>
              <label class="switch">
                <input type="checkbox" ${alarm.active ? "checked" : ""}>
                <span class="slider"></span>
              </label>
            `;
            // Add change listener to save toggle state changes
            newAlarm.querySelector("input[type='checkbox']").addEventListener("change", saveAlarmsToLocalStorage);
            alarmsList.appendChild(newAlarm);
          });
        }
      }
    } catch (e) {
      console.warn("Could not load alarms", e);
    }
  }

  // Load profile and alarms on initialization
  loadAlarmsFromLocalStorage();
  updateProfileUI(userDetails.name === "Guest" ? "guest" : "google");


  // --- Badge: mark alarms that won't ring today ---
  function updateAlarmTodayBadges() {
    const jsDay = new Date().getDay();
    const dayNamesShort = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    const currentDayName = dayNamesShort[jsDay];

    document.querySelectorAll(".alarm-item").forEach(item => {
      const infoText = item.querySelector(".alarm-time-info p");
      if (!infoText) return;
      const parts = infoText.textContent.split("\u2022");
      if (parts.length < 2) return;
      const daysPart = parts[1].trim();

      let firesOnToday = false;
      if (daysPart === "Everyday" || daysPart === "Once") {
        firesOnToday = true;
      } else if (daysPart === "Mon-Fri") {
        firesOnToday = jsDay >= 1 && jsDay <= 5;
      } else if (daysPart === "Sat, Sun") {
        firesOnToday = jsDay === 0 || jsDay === 6;
      } else {
        firesOnToday = daysPart.split(",").map(d => d.trim()).includes(currentDayName);
      }

      // Remove old badge
      const oldBadge = item.querySelector(".no-ring-today");
      if (oldBadge) oldBadge.remove();

      if (!firesOnToday) {
        const badge = document.createElement("span");
        badge.className = "no-ring-today";
        badge.textContent = "\u26a0\ufe0f Won't ring today";
        const info = item.querySelector(".alarm-time-info");
        if (info) info.appendChild(badge);
      }
    });
  }

  // Run once on load
  updateAlarmTodayBadges();
  // --- Real-time Alarm Monitor ---
  // Tracks the last minute an alarm was fired to prevent duplicate triggers.
  let lastFiredMinute = "";

  setInterval(() => {
    const activeView = document.querySelector(".view.active");
    if (!activeView) return;
    if (["view-ringing", "view-camera", "view-success"].includes(activeView.id)) return;

    const now = new Date();
    const currentH = now.getHours();
    const currentM = now.getMinutes();
    const current24 = `${currentH < 10 ? "0"+currentH : currentH}:${currentM < 10 ? "0"+currentM : currentM}`;
    const jsDay = now.getDay();
    const dayNamesShort = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    const currentDayName = dayNamesShort[jsDay];

    document.querySelectorAll(".alarm-item").forEach(item => {
      const checkbox = item.querySelector("input[type='checkbox']");
      if (!checkbox || !checkbox.checked) return;

      // --- Get 24h time for this alarm ---
      let alarmTime24 = item.getAttribute("data-time24");

      // Fallback: parse from displayed "HH:MM AM/PM" if attribute is missing
      if (!alarmTime24) {
        const h2 = item.querySelector(".alarm-time-info h2");
        if (!h2) return;
        const ampmSpan = h2.querySelector("span");
        const ampm = ampmSpan ? ampmSpan.textContent.trim() : "AM";
        const tmp = document.createElement("div");
        tmp.innerHTML = h2.innerHTML;
        const sp = tmp.querySelector("span");
        if (sp) sp.remove();
        const rawTime = tmp.textContent.trim(); // e.g. "09:01"
        const tp = rawTime.split(":");
        if (tp.length < 2) return;
        let h = parseInt(tp[0]);
        const m = tp[1].trim();
        if (ampm === "AM") {
          if (h === 12) h = 0;
        } else {
          if (h !== 12) h += 12;
        }
        alarmTime24 = `${h < 10 ? "0"+h : h}:${m}`;
        item.setAttribute("data-time24", alarmTime24); // cache it
      }

      if (alarmTime24 !== current24) return;

      // Prevent firing more than once per minute for the same alarm
      const fireKey = `${alarmTime24}-${jsDay}`;
      if (lastFiredMinute === fireKey) return;

      // --- Day matching ---
      const infoText = item.querySelector(".alarm-time-info p");
      if (!infoText) return;
      const parts = infoText.textContent.split("•");
      if (parts.length < 2) return;
      const daysPart = parts[1].trim();
      let dayMatches = false;
      if (daysPart === "Everyday" || daysPart === "Once") {
        dayMatches = true;
      } else if (daysPart === "Mon-Fri") {
        dayMatches = jsDay >= 1 && jsDay <= 5;
      } else if (daysPart === "Sat, Sun") {
        dayMatches = jsDay === 0 || jsDay === 6;
      } else {
        dayMatches = daysPart.split(",").map(d => d.trim()).includes(currentDayName);
      }
      if (!dayMatches) return;

      // --- Parse exercise ---
      const challengeString = parts[0].trim();
      const repsMatch = challengeString.match(/(\d+)\s+reps/);
      const reps = repsMatch ? parseInt(repsMatch[1]) : 10;
      const exercise = challengeString.split("-")[0].trim();

      // --- Mark as fired this minute ---
      lastFiredMinute = fireKey;

      userDetails.exerciseType = exercise;
      userDetails.repetitions = reps;

      // Build 12h display for ringing screen
      let dispH = currentH % 12;
      dispH = dispH ? dispH : 12;
      const dispAmPm = currentH >= 12 ? "PM" : "AM";
      const dispTime = `${dispH < 10 ? "0"+dispH : dispH}:${currentM < 10 ? "0"+currentM : currentM}`;

      document.getElementById("challenge-detail").textContent = `${reps} ${exercise}`;
      document.getElementById("camera-exercise-title").textContent = exercise;
      document.getElementById("camera-target-subtitle").textContent = `Target: ${reps} reps`;
      document.querySelector(".total-reps").textContent = `/ ${reps}`;
      document.getElementById("ringing-time-display").innerHTML =
        `${dispTime} <span style="font-size:24px">${dispAmPm}</span>`;

      switchView("ringing");
      startAlarmSound();
    });
  }, 1000);

  // Logout action
  document.getElementById("logout-btn").addEventListener("click", () => {
    switchView("login");
  });
});
