import { useCallback, useEffect, useState } from "react";
import type { FormEvent } from "react";
import "./App.css";

type User = { username: string; role: string };
type Course = {
  courseId: number;
  courseName: string;
  description: string;
  createTime: string;
};
type Resource = {
  id: number;
  resourceName: string;
  sizeBytes: number;
  createTime: string;
};
type Chapter = {
  chapterId: number;
  chapterName: string;
  description: string;
  resources: Resource[];
};
type Page<T> = { total: number; records: T[] };
type Login = { token: string; userInfo: User };
type Envelope<T> = { code: number; message: string; data: T };
const PAGE_SIZE = 10;

const base = import.meta.env.VITE_API_BASE ?? "";
async function api<T>(
  path: string,
  token: string | null,
  init?: RequestInit,
): Promise<T> {
  const headers = new Headers(init?.headers);
  if (token) headers.set("Authorization", `Bearer ${token}`);
  if (init?.body && !(init.body instanceof FormData))
    headers.set("Content-Type", "application/json");
  const response = await fetch(base + path, { ...init, headers });
  const result = (await response.json()) as Envelope<T>;
  if (!response.ok || result.code !== 200)
    throw new Error(result.message || "请求失败");
  return result.data;
}

function Pager({
  page,
  total,
  onChange,
  label = "",
}: {
  page: number;
  total: number;
  onChange: (page: number) => void;
  label?: string;
}) {
  if (total <= PAGE_SIZE) return null;
  return (
    <div className="pager">
      <button disabled={page <= 1} onClick={() => onChange(page - 1)}>
        上一页
      </button>
      <span>
        {label}第 {page} / {Math.ceil(total / PAGE_SIZE)} 页
      </span>
      <button
        disabled={page * PAGE_SIZE >= total}
        onClick={() => onChange(page + 1)}
      >
        下一页
      </button>
    </div>
  );
}

function App() {
  const [token, setToken] = useState<string | null>(() =>
    sessionStorage.getItem("teacher-token"),
  );
  const [username, setUsername] = useState(
    () => sessionStorage.getItem("teacher-name") ?? "",
  );
  const [courses, setCourses] = useState<Course[]>([]);
  const [resources, setResources] = useState<Resource[]>([]);
  const [chapters, setChapters] = useState<Chapter[]>([]);
  const [coursePage, setCoursePage] = useState(1);
  const [resourcePage, setResourcePage] = useState(1);
  const [chapterPage, setChapterPage] = useState(1);
  const [courseTotal, setCourseTotal] = useState(0);
  const [resourceTotal, setResourceTotal] = useState(0);
  const [chapterTotal, setChapterTotal] = useState(0);
  const [selected, setSelected] = useState<Course | null>(null);
  const [view, setView] = useState<"courses" | "resources">("courses");
  const [notice, setNotice] = useState("");
  const [busy, setBusy] = useState(false);
  const [register, setRegister] = useState(false);
  const [password, setPassword] = useState("");
  const [courseName, setCourseName] = useState("");
  const [courseDescription, setCourseDescription] = useState("");
  const [chapterName, setChapterName] = useState("");
  const [chapterDescription, setChapterDescription] = useState("");
  const [choices, setChoices] = useState<Record<number, string>>({});

  const loadCourses = useCallback(
    async (page = 1) => {
      if (token) {
        const result = await api<Page<Course>>(
          `/courses?pageNum=${page}&pageSize=${PAGE_SIZE}`,
          token,
        );
        setCourses(result.records);
        setCourseTotal(result.total);
      }
    },
    [token],
  );
  const loadResources = useCallback(
    async (page = 1) => {
      if (token) {
        const result = await api<Page<Resource>>(
          `/resources?pageNum=${page}&pageSize=${PAGE_SIZE}`,
          token,
        );
        setResources(result.records);
        setResourceTotal(result.total);
      }
    },
    [token],
  );
  const loadChapters = useCallback(
    async (courseId: number, page = 1) => {
      if (token) {
        const result = await api<Page<Chapter>>(
          `/courses/${courseId}/chapters?pageNum=${page}&pageSize=${PAGE_SIZE}`,
          token,
        );
        setChapters(result.records);
        setChapterTotal(result.total);
      }
    },
    [token],
  );
  useEffect(() => {
    if (!token) return;
    let active = true;
    void Promise.all([
      api<Page<Course>>(`/courses?pageNum=1&pageSize=${PAGE_SIZE}`, token),
      api<Page<Resource>>(`/resources?pageNum=1&pageSize=${PAGE_SIZE}`, token),
    ])
      .then(([coursePage, resourcePage]) => {
        if (active) {
          setCourses(coursePage.records);
          setCourseTotal(coursePage.total);
          setResources(resourcePage.records);
          setResourceTotal(resourcePage.total);
        }
      })
      .catch((error) => {
        if (active) showError(error);
      });
    return () => {
      active = false;
    };
  }, [token]);
  function showError(error: unknown) {
    setNotice(error instanceof Error ? error.message : "操作失败");
  }
  async function run(action: () => Promise<void>, success: string) {
    setBusy(true);
    setNotice("");
    try {
      await action();
      setNotice(success);
    } catch (error) {
      showError(error);
    } finally {
      setBusy(false);
    }
  }
  async function submitAuth(event: FormEvent) {
    event.preventDefault();
    await run(
      async () => {
        if (register)
          await api("/auth/register", null, {
            method: "POST",
            body: JSON.stringify({
              username: username.trim(),
              password,
              role: "teacher",
            }),
          });
        const login = await api<Login>("/auth/login", null, {
          method: "POST",
          body: JSON.stringify({ username: username.trim(), password }),
        });
        if (login.userInfo.role !== "teacher")
          throw new Error("教师工作台仅支持教师账号");
        sessionStorage.setItem("teacher-token", login.token);
        sessionStorage.setItem("teacher-name", login.userInfo.username);
        setToken(login.token);
        setUsername(login.userInfo.username);
        setPassword("");
      },
      register ? "账号已创建，欢迎开始备课。" : "登录成功。",
    );
  }
  function logout() {
    sessionStorage.removeItem("teacher-token");
    sessionStorage.removeItem("teacher-name");
    setToken(null);
    setSelected(null);
    setCourses([]);
    setResources([]);
    setChapters([]);
    setCoursePage(1);
    setResourcePage(1);
    setChapterPage(1);
  }
  async function openCourse(course: Course) {
    setSelected(course);
    setNotice("");
    setChapterPage(1);
    try {
      await loadChapters(course.courseId);
    } catch (error) {
      showError(error);
    }
  }
  async function createCourse(event: FormEvent) {
    event.preventDefault();
    await run(async () => {
      await api("/courses", token, {
        method: "POST",
        body: JSON.stringify({
          courseName: courseName.trim(),
          description: courseDescription.trim(),
        }),
      });
      setCourseName("");
      setCourseDescription("");
      setCoursePage(1);
      await loadCourses(1);
    }, "课程已创建。");
  }
  async function createChapter(event: FormEvent) {
    event.preventDefault();
    if (!selected) return;
    await run(async () => {
      await api(`/courses/${selected.courseId}/chapters`, token, {
        method: "POST",
        body: JSON.stringify({
          chapterName: chapterName.trim(),
          description: chapterDescription.trim(),
        }),
      });
      const lastPage = Math.ceil((chapterTotal + 1) / PAGE_SIZE);
      setChapterName("");
      setChapterDescription("");
      setChapterPage(lastPage);
      await loadChapters(selected.courseId, lastPage);
    }, "章节已添加。");
  }
  async function upload(file: File) {
    const form = new FormData();
    form.append("file", file);
    await run(async () => {
      await api("/resources", token, { method: "POST", body: form });
      setResourcePage(1);
      await loadResources(1);
    }, "资料已上传。");
  }
  async function attach(chapterId: number) {
    if (!selected || !choices[chapterId]) return;
    await run(async () => {
      await api(
        `/courses/${selected.courseId}/chapters/${chapterId}/resources`,
        token,
        {
          method: "POST",
          body: JSON.stringify({ resourceId: Number(choices[chapterId]) }),
        },
      );
      setChoices({ ...choices, [chapterId]: "" });
      await loadChapters(selected.courseId, chapterPage);
    }, "资料已加入章节。");
  }
  async function detach(chapterId: number, resourceId: number) {
    if (!selected) return;
    await run(async () => {
      await api(
        `/courses/${selected.courseId}/chapters/${chapterId}/resources/${resourceId}`,
        token,
        { method: "DELETE" },
      );
      await loadChapters(selected.courseId, chapterPage);
    }, "资料已从章节移除，资源库中的文件仍然保留。");
  }
  async function deleteResource(id: number) {
    if (!confirm("确定删除这份资料吗？已加入章节的资料需要先移除。")) return;
    await run(async () => {
      await api(`/resources/${id}`, token, { method: "DELETE" });
      const nextPage = Math.max(1, Math.ceil((resourceTotal - 1) / PAGE_SIZE));
      const page = Math.min(resourcePage, nextPage);
      setResourcePage(page);
      await loadResources(page);
    }, "资料已删除。");
  }
  async function download(resource: Resource) {
    try {
      const response = await fetch(`${base}/resources/${resource.id}/content`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      if (!response.ok) throw new Error("下载失败");
      const url = URL.createObjectURL(await response.blob());
      const a = document.createElement("a");
      a.href = url;
      a.download = resource.resourceName;
      a.click();
      setTimeout(() => URL.revokeObjectURL(url), 1000);
    } catch (error) {
      showError(error);
    }
  }

  if (!token)
    return (
      <main className="auth-page">
        <div className="brand">
          备课间 <span>TEACHER WORKSPACE</span>
        </div>
        <div className="auth-layout">
          <section className="auth-intro">
            <p className="eyebrow">把备课资料放回课程里</p>
            <h1>
              从一门课程开始，
              <br />
              整理好每一节课。
            </h1>
            <p>
              建立课程、编排章节、上传资料，再把合适的资料放进章节。备课思路和文件，不必散落在各处。
            </p>
            <div className="steps">01 建课程　　02 编章节　　03 选资料</div>
          </section>
          <section className="auth-card">
            <p className="eyebrow">教师工作台</p>
            <h2>{register ? "创建教师账号" : "欢迎回来"}</h2>
            <p className="muted">登录后继续整理你的课程。</p>
            <form onSubmit={submitAuth}>
              <label>
                用户名
                <input
                  required
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  placeholder="请输入用户名"
                />
              </label>
              <label>
                密码
                <input
                  required
                  type="password"
                  minLength={6}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="请输入密码"
                />
              </label>
              <button className="primary" disabled={busy}>
                {busy ? "请稍候…" : register ? "创建并登录" : "登录工作台"}
              </button>
            </form>
            <button
              className="link"
              onClick={() => {
                setRegister(!register);
                setNotice("");
              }}
            >
              {register ? "已有账号？返回登录" : "还没有账号？注册教师账号"}
            </button>
            {notice && (
              <p className="notice" role="status">
                {notice}
              </p>
            )}
          </section>
        </div>
      </main>
    );

  return (
    <div className="workspace">
      <aside className="sidebar">
        <div className="brand">
          备课间 <span>TEACHER WORKSPACE</span>
        </div>
        <nav aria-label="主导航">
          <button
            className={view === "courses" ? "active" : ""}
            onClick={() => {
              setView("courses");
              setSelected(null);
            }}
          >
            ▦　我的课程
          </button>
          <button
            className={view === "resources" ? "active" : ""}
            onClick={() => {
              setView("resources");
              setSelected(null);
            }}
          >
            ▤　资源库
          </button>
        </nav>
        <div className="account">
          <div className="avatar">{username.slice(0, 1).toUpperCase()}</div>
          <strong>{username}</strong>
          <button onClick={logout}>退出</button>
        </div>
      </aside>
      <main className="main">
        <header className="topbar">
          教师工作台{" "}
          <span>
            /{" "}
            {view === "resources"
              ? "资源库"
              : (selected?.courseName ?? "我的课程")}
          </span>
        </header>
        {notice && (
          <div className="notice" role="status">
            {notice}
            <button onClick={() => setNotice("")}>×</button>
          </div>
        )}
        {view === "courses" && !selected && (
          <>
            <div className="heading">
              <div>
                <p className="eyebrow">COURSES</p>
                <h1>我的课程</h1>
                <p className="muted">把课程内容和备课资料整理在同一个地方。</p>
              </div>
              <div className="count">
                <strong>{courseTotal}</strong>门课程
              </div>
            </div>
            <div className="grid">
              <section className="panel">
                <div className="panel-head">
                  <h2>课程列表</h2>
                  <small>选择一门课程继续编排</small>
                </div>
                {courses.length ? (
                  courses.map((course) => (
                    <button
                      className="course"
                      key={course.courseId}
                      onClick={() => openCourse(course)}
                    >
                      <span className="icon">
                        {course.courseName.slice(0, 1)}
                      </span>
                      <span>
                        <strong>{course.courseName}</strong>
                        <small>{course.description || "暂无课程说明"}</small>
                      </span>
                      <b>→</b>
                    </button>
                  ))
                ) : (
                  <div className="empty">
                    还没有课程。先从右侧创建第一门课程。
                  </div>
                )}
                <Pager
                  page={coursePage}
                  total={courseTotal}
                  onChange={(page) => {
                    setCoursePage(page);
                    void loadCourses(page).catch(showError);
                  }}
                />
              </section>
              <section className="panel form-panel">
                <div className="panel-head">
                  <h2>新建课程</h2>
                </div>
                <form onSubmit={createCourse}>
                  <label>
                    课程名称
                    <input
                      required
                      maxLength={100}
                      value={courseName}
                      onChange={(e) => setCourseName(e.target.value)}
                      placeholder="例如：数据结构基础"
                    />
                  </label>
                  <label>
                    课程说明
                    <textarea
                      maxLength={500}
                      rows={4}
                      value={courseDescription}
                      onChange={(e) => setCourseDescription(e.target.value)}
                      placeholder="这门课主要讲什么？"
                    />
                  </label>
                  <button className="primary" disabled={busy}>
                    创建课程
                  </button>
                </form>
              </section>
            </div>
          </>
        )}
        {view === "courses" && selected && (
          <>
            <button
              className="back"
              onClick={() => {
                setSelected(null);
                setChapters([]);
              }}
            >
              ← 返回我的课程
            </button>
            <div className="heading">
              <div>
                <p className="eyebrow">COURSE PLAN</p>
                <h1>{selected.courseName}</h1>
                <p className="muted">
                  {selected.description ||
                    "按教学顺序编排章节，并加入备课资料。"}
                </p>
              </div>
              <div className="count">
                <strong>{chapterTotal}</strong>个章节
              </div>
            </div>
            <div className="grid">
              <section className="panel">
                <div className="panel-head">
                  <h2>章节安排</h2>
                  <small>每份资料可以用于多个章节</small>
                </div>
                {chapters.length ? (
                  chapters.map((chapter, index) => (
                    <article className="chapter" key={chapter.chapterId}>
                      <div className="chapter-head">
                        <span className="number">
                          {String(
                            (chapterPage - 1) * PAGE_SIZE + index + 1,
                          ).padStart(2, "0")}
                        </span>
                        <div>
                          <h3>{chapter.chapterName}</h3>
                          <p>{chapter.description || "暂无章节说明"}</p>
                        </div>
                      </div>
                      <div className="attachments">
                        {chapter.resources?.length ? (
                          chapter.resources.map((resource) => (
                            <div className="attachment" key={resource.id}>
                              <button onClick={() => download(resource)}>
                                ▤　{resource.resourceName}
                              </button>
                              <button
                                className="quiet"
                                disabled={busy}
                                onClick={() =>
                                  detach(chapter.chapterId, resource.id)
                                }
                              >
                                移除
                              </button>
                            </div>
                          ))
                        ) : (
                          <p>尚未加入资料</p>
                        )}
                      </div>
                      <div className="attach">
                        <select
                          aria-label={`为${chapter.chapterName}选择资料`}
                          value={choices[chapter.chapterId] ?? ""}
                          onChange={(e) =>
                            setChoices({
                              ...choices,
                              [chapter.chapterId]: e.target.value,
                            })
                          }
                        >
                          <option value="">从资源库选择资料</option>
                          {resources
                            .filter(
                              (r) =>
                                !chapter.resources?.some(
                                  (item) => item.id === r.id,
                                ),
                            )
                            .map((r) => (
                              <option key={r.id} value={r.id}>
                                {r.resourceName}
                              </option>
                            ))}
                        </select>
                        <button
                          className="secondary"
                          disabled={busy || !choices[chapter.chapterId]}
                          onClick={() => attach(chapter.chapterId)}
                        >
                          加入章节
                        </button>
                      </div>
                    </article>
                  ))
                ) : (
                  <div className="empty">
                    还没有章节。添加章节后，就可以加入资源库里的资料。
                  </div>
                )}
                <Pager
                  page={chapterPage}
                  total={chapterTotal}
                  onChange={(page) => {
                    setChapterPage(page);
                    void loadChapters(selected.courseId, page).catch(showError);
                  }}
                />
                <Pager
                  label="可选资料 "
                  page={resourcePage}
                  total={resourceTotal}
                  onChange={(page) => {
                    setResourcePage(page);
                    void loadResources(page).catch(showError);
                  }}
                />
              </section>
              <section className="panel form-panel">
                <div className="panel-head">
                  <h2>添加章节</h2>
                </div>
                <form onSubmit={createChapter}>
                  <label>
                    章节名称
                    <input
                      required
                      maxLength={100}
                      value={chapterName}
                      onChange={(e) => setChapterName(e.target.value)}
                      placeholder="例如：第一章 线性表"
                    />
                  </label>
                  <label>
                    章节说明
                    <textarea
                      rows={4}
                      maxLength={500}
                      value={chapterDescription}
                      onChange={(e) => setChapterDescription(e.target.value)}
                      placeholder="这一章希望学生掌握什么？"
                    />
                  </label>
                  <button className="primary" disabled={busy}>
                    添加章节
                  </button>
                </form>
                <p className="hint">
                  还没有资料？前往左侧「资源库」上传，再回到课程加入章节。
                </p>
              </section>
            </div>
          </>
        )}
        {view === "resources" && (
          <>
            <div className="heading">
              <div>
                <p className="eyebrow">LIBRARY</p>
                <h1>我的资源库</h1>
                <p className="muted">
                  课件、讲义和视频先存在这里，需要时再加入章节。
                </p>
              </div>
              <div className="count">
                <strong>{resourceTotal}</strong>份资料
              </div>
            </div>
            <div className="grid">
              <section className="panel">
                <div className="panel-head">
                  <h2>全部资料</h2>
                  <small>点击文件名可下载</small>
                </div>
                {resources.length ? (
                  resources.map((resource) => (
                    <div className="resource" key={resource.id}>
                      <span className="icon">▤</span>
                      <div>
                        <button onClick={() => download(resource)}>
                          {resource.resourceName}
                        </button>
                        <small>
                          {resource.createTime
                            ? new Date(resource.createTime).toLocaleDateString(
                                "zh-CN",
                              )
                            : "—"}{" "}
                          ·{" "}
                          {resource.sizeBytes
                            ? (resource.sizeBytes / 1024 / 1024).toFixed(2) +
                              " MB"
                            : "文件"}
                        </small>
                      </div>
                      <button
                        className="quiet"
                        disabled={busy}
                        onClick={() => deleteResource(resource.id)}
                      >
                        删除
                      </button>
                    </div>
                  ))
                ) : (
                  <div className="empty">
                    资源库还是空的。上传一份资料，开始整理课程内容。
                  </div>
                )}
                <Pager
                  page={resourcePage}
                  total={resourceTotal}
                  onChange={(page) => {
                    setResourcePage(page);
                    void loadResources(page).catch(showError);
                  }}
                />
              </section>
              <section className="panel form-panel">
                <div className="panel-head">
                  <h2>上传资料</h2>
                </div>
                <label className="upload">
                  <span>↑</span>
                  <strong>选择文件上传</strong>
                  <small>单个文件不超过 20 MB</small>
                  <input
                    type="file"
                    disabled={busy}
                    onChange={(e) => {
                      const file = e.target.files?.[0];
                      if (file) void upload(file);
                      e.target.value = "";
                    }}
                  />
                </label>
                <p className="hint">
                  资料可以用于多个章节。已被引用的资料，需要先移除引用才能删除。
                </p>
              </section>
            </div>
          </>
        )}
      </main>
    </div>
  );
}
export default App;
